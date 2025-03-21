# privileged.nix
{ config, pkgs, lib, ... }:

let
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

        # Install systemd service
        echo "Installing systemd service..."
        cat > "$BUILD_DIR/borg.service" << 'EOF'
    [Unit]
    Description=Borg Backup
    [Service]
    Type=oneshot
    ExecStart=/usr/bin/systemd-inhibit --what=sleep:shutdown:idle --who="borg backup" --why="Backup in progress" /etc/privileged-dotfiles/backup_data.sh
    StandardOutput=append:/var/log/borg_backup.log
    StandardError=append:/var/log/borg_backup.log
    [Install]
    WantedBy=multi-user.target
    EOF

        # Install systemd timer
        echo "Installing systemd timer..."
        cat > "$BUILD_DIR/borg.timer" << 'EOF'
    [Unit]
    Description=Borg Backup Timer

    [Timer]
    OnCalendar=daily
    Persistent=true

    [Install]
    WantedBy=timers.target
    EOF

        # Install service and timer files
        echo "Installing new systemd files..."
        install -v -m 644 -o root -g root "$BUILD_DIR/borg.service" /etc/systemd/system/
        install -v -m 644 -o root -g root "$BUILD_DIR/borg.timer" /etc/systemd/system/

        echo "Reloading systemd..."
        systemctl daemon-reload

        echo "Enabling and starting services..."
        systemctl enable borg.service
        systemctl enable borg.timer
        systemctl start borg.timer

        # Set up logwatch configuration
        echo "Setting up logwatch configuration..."
        mkdir -p /etc/logwatch/conf
        # Check if user's logwatch config exists
        if [[ -f "${config.home.homeDirectory}/.config/logwatch/ignore.conf" ]]; then
          # Create symlink to user's config if it exists
          echo "Linking user's logwatch ignore configuration..."
          cp -f "${config.home.homeDirectory}/.config/logwatch/ignore.conf" /etc/logwatch/conf/ignore.conf
        else
          echo "User's logwatch configuration not found at ${config.home.homeDirectory}/.config/logwatch/ignore.conf"
        fi

        # Set up services directory if needed
        mkdir -p /etc/logwatch/conf/services
        if [[ -d "${config.home.homeDirectory}/.config/logwatch/services" ]]; then
          echo "Linking user's logwatch service configurations..."
          for config_file in "${config.home.homeDirectory}/.config/logwatch/services/"*.conf; do
            if [[ -f "$config_file" ]]; then
              basename=$(basename "$config_file")
              cp -f "$config_file" "/etc/logwatch/conf/services/$basename"
              echo "Linked $basename"
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
