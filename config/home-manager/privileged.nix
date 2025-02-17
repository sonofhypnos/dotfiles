# privileged.nix
{ config, pkgs, lib, ... }:

let
  deployPrivilegedPackage = pkgs.writeScriptBin "deploy-privileged" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    SCRIPT_PATH="/home/tassilo/.nix-profile/bin/deploy-privileged"

    if [[ $EUID -ne 0 ]]; then
      echo "Escalating privileges for deployment..."
      exec sudo "$SCRIPT_PATH"
    fi

    echo "Running privileged deployment..."
    echo "Using script from: $SCRIPT_PATH"

    # Create secure build directory
    BUILD_DIR="$(mktemp -d)"
    trap 'rm -rf "$BUILD_DIR"' EXIT
    chmod 700 "$BUILD_DIR"

    # Deploy backup script with explicit feedback
    echo "Creating privileged directory..."
    install -v -d -m 700 -o root -g root /etc/privileged-dotfiles

    echo "Installing backup script..."
    install -v -m 600 -o root -g root "${config.home.homeDirectory}/bin/backup_data.sh" /etc/privileged-dotfiles/

    echo "Reloading systemd..."
    systemctl daemon-reload

    echo "Deployment complete! Files installed:"
    ls -la /etc/privileged-dotfiles/
  '';

in {
  options.privileged = {
    enable = lib.mkEnableOption "privileged file deployment";
  };

  config = lib.mkIf config.privileged.enable {
    # Just install the script, don't try to run it during activation
    home.packages = [ deployPrivilegedPackage ];
  };
}
