#!/usr/bin/env bash   
#title          :save_ssh_keys.sh
#description    :Saves my ssh keys to 1password
#author         :Tassilo Neubauer
#date           :20240521
#version        :0.1    
#usage          :./save_ssh_keys.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================
# TODO: Make sure this reliably is run even if the job for this is executed from root user


# Directory containing SSH keys
SSH_DIR=~/.ssh

# Login to 1Password CLI and store the session token
OP_SESSION=$(op signin --raw)

# Function to add SSH key to 1Password
add_ssh_key_to_1password() {
  local private_key_path=$1
  local public_key_path="${private_key_path}.pub"

  # Ensure public key exists
  if [ ! -f "$public_key_path" ]; then
    echo "Public key for $private_key_path does not exist, skipping..."
    return
  fi

  local key_name=$(basename "$private_key_path")

  # Read key content
  local private_key_content=$(cat "$private_key_path")
  local public_key_content=$(cat "$public_key_path")

  # Create a new SSH Key item in 1Password
  echo "Adding $key_name to 1Password..."
  op item create --category=ssh-key --title="$key_name" \
    --vault='Private' --session="$OP_SESSION" \
    "Keys.private[password]=$private_key_content" \
    "Keys.public[concealed]=$public_key_content"
}

# Loop through private SSH keys in the SSH directory
for key in $SSH_DIR/id_*; do
  if [[ $key != *.pub ]]; then  # Ignore public keys
    add_ssh_key_to_1password "$key"
  fi
done
