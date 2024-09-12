#!/bin/bash

# Variables
TERRAFORM_DIR="./terraform"
ANSIBLE_DIR="./ansible"
INVENTORY_FILE="${ANSIBLE_DIR}/inventory.txt"
PRIVATE_KEY_FILE="${ANSIBLE_DIR}/ssh_key.pem"


run_terraform() {
    echo "=== Destroy Terraform ==="
    cd "$TERRAFORM_DIR" || exit
    terraform destroy -auto-approve
    cd - || exit
}

run_ansible() {
    echo "=== Destroy configuration Ansible ==="
    rm -rf "$INVENTORY_FILE" "$PRIVATE_KEY_FILE"
}

main() {
    echo "=== Destruction de l'infrastructure ==="
    run_terraform
    run_ansible
    echo "=== Destruction terminé avec succès ==="
}

main