# privileged.nix
{ config, pkgs, lib, ... }:

let
  # Create a proper package for the deploy script
  deployPrivilegedPackage = pkgs.writeScriptBin "deploy-privileged" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    if [[ $EUID -ne 0 ]]; then
      echo "This script must be run as root"
      exit 1
    fi

    # Create secure build directory
    BUILD_DIR="$(mktemp -d)"
    trap 'rm -rf "$BUILD_DIR"' EXIT
    chmod 700 "$BUILD_DIR"

    # Deploy backup script
    install -d -m 700 -o root -g root /etc/privileged-dotfiles
    install -m 600 -o root -g root "${config.home.homeDirectory}/bin/backup_data.sh" /etc/privileged-dotfiles/

    # Update systemd if needed
    systemctl daemon-reload
  '';

in {
  options.privileged = {
    enable = lib.mkEnableOption "privileged file deployment";
  };

  config = lib.mkIf config.privileged.enable {
    # Add the deploy script to path
    home.packages = [ deployPrivilegedPackage ];

    # Run during home-manager activation
    home.activation.deployPrivileged =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${deployPrivilegedPackage}/bin/deploy-privileged
      '';
  };
}
