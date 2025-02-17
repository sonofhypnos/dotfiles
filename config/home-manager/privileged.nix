# privileged.nix
{ config, pkgs, lib, ... }:

let
  # Helper to check git state
  verifyGitState = pkgs.writeScript "verify-git-state" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    cd "$(git rev-parse --show-toplevel)"

    if [[ -n "$(git status --porcelain)" ]]; then
      echo "Error: Git repository has uncommitted changes!"
      exit 1
    fi

    # Optionally verify commits are signed
    if ! git verify-commit HEAD; then
      echo "Error: HEAD commit is not signed!"
      exit 1
    fi
  '';

  # Deployment script that requires root
  deployPrivileged = pkgs.writeScript "deploy-privileged" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    if [[ $EUID -ne 0 ]]; then
      echo "This script must be run as root"
      exit 1
    fi

    # Create root-owned directory if it doesn't exist
    install -d -m 700 -o root -g root /etc/privileged-dotfiles

    # Deploy files with restricted permissions
    install -m 600 -o root -g root $targetFiles/* /etc/privileged-dotfiles/

    # Run any necessary post-deployment commands (service restarts etc)
    systemctl daemon-reload
  '';

  # List of files that need root ownership
  privilegedFiles = [
    config.home.file."bin/backup_data.sh".source
    # Add other files that need root privileges
  ];

in {
  # Your normal home-manager config remains here
  home.file = {
    # Regular unprivileged files...
  };

  # New privileged variant
  options.privileged = {
    enable = lib.mkEnableOption "privileged file deployment";

    files = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = "Files that require root privileges";
    };
  };

  config = lib.mkIf config.privileged.enable {
    home.activation.deployPrivileged =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # First verify git state
        ${verifyGitState}

        # Then deploy privileged files
        sudo ${deployPrivileged}
      '';
  };
}
