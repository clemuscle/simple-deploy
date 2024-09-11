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
}

main() {
    echo "=== Destruction de l'infrastructure ==="
    run_terraform
    echo "=== Destruction terminé avec succès ==="
}

main