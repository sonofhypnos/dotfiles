{ config, pkgs, lib, ... }:

let
  # Paths to your correct service and timer
  borgServiceFile = ../systemd/user/borg.service;
  borgTimerFile = ../systemd/user/borg.timer;

  deployPrivilegedPackage = pkgs.writeScriptBin "deploy-privileged" ''
    #!${pkgs.bash}/bin/bash

    SCRIPT_PATH="/home/tassilo/.nix-profile/bin/deploy-privileged"

    if [[ $EUID -ne 0 ]]; then
      echo "Escalating privileges for deployment..."
      exec sudo "$SCRIPT_PATH"
    fi

    echo "Running privileged deployment..."

    # Create secure build directory
    BUILD_DIR="$(mktemp -d)"
    trap 'rm -rf "$BUILD_DIR"' EXIT
    chmod 700 "$BUILD_DIR"

    # Deploy backup script
    echo "Creating privileged directory..."
    install -v -d -m 700 -o root -g root /etc/privileged-dotfiles

    echo "Installing backup script..."
    install -v -m 700 -o root -g root "${config.home.homeDirectory}/bin/backup_data.sh" /etc/privileged-dotfiles/

    # Copy systemd service and timer from trusted sources
    echo "Copying borg.service and borg.timer..."
    install -v -m 644 -o root -g root "${borgServiceFile}" /etc/systemd/system/borg.service
    install -v -m 644 -o root -g root "${borgTimerFile}" /etc/systemd/system/borg.timer

    echo "Reloading systemd..."
    systemctl daemon-reload

    echo "Enabling and starting services..."
    systemctl enable borg.service
    systemctl enable borg.timer
    systemctl start borg.timer

    # Set up logwatch configuration
    echo "Setting up logwatch configuration..."
    mkdir -p /etc/logwatch/conf
    if [[ -f "${config.home.homeDirectory}/.config/logwatch/ignore.conf" ]]; then
      echo "Copying user's logwatch ignore configuration..."
      cp -f "${config.home.homeDirectory}/.config/logwatch/ignore.conf" /etc/logwatch/conf/ignore.conf
    else
      echo "User's logwatch configuration not found."
    fi

    mkdir -p /etc/logwatch/conf/services
    if [[ -d "${config.home.homeDirectory}/.config/logwatch/services" ]]; then
      echo "Copying user's logwatch service configurations..."
      for config_file in "${config.home.homeDirectory}/.config/logwatch/services/"*.conf; do
        if [[ -f "$config_file" ]]; then
          basename=$(basename "$config_file")
          cp -f "$config_file" "/etc/logwatch/conf/services/$basename"
          echo "Copied $basename"
        fi
      done
    fi

    echo "Deployment complete! Files installed:"
    echo "Script:"
    ls -la /etc/privileged-dotfiles/
    echo "Systemd files:"
    ls -la /etc/systemd/system/borg.*
    echo "Logwatch configuration:"
    ls -la /etc/logwatch/conf/
  '';
in {
  options.privileged = {
    enable = lib.mkEnableOption "privileged file deployment";
  };

  config = lib.mkIf config.privileged.enable {
    home.packages = [ deployPrivilegedPackage ];
  };
}
