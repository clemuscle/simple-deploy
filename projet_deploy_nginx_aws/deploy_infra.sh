#!/bin/bash

# Variables
TERRAFORM_DIR="./terraform"
ANSIBLE_DIR="./ansible"
INVENTORY_FILE="${ANSIBLE_DIR}/inventory.txt"
PRIVATE_KEY_FILE="${ANSIBLE_DIR}/ssh_key.pem"


run_terraform() {
    echo "=== Initialisation de Terraform ==="
    cd "$TERRAFORM_DIR" || exit
    terraform init

    echo "=== Application de la configuration Terraform =="
    terraform apply -auto-approve

    INSTANCE_IP=$(terraform output -raw instance_ip)
    PRIVATE_KEY=$(terraform output -raw private_key)
    
    if [ -z "$INSTANCE_IP" ]; then
        echo "Erreur : Impossible de récupérer l'adresse IP de l'instance."
        exit 1
    fi

    if [ -z "$PRIVATE_KEY" ]; then
        echo "Erreur : Impossible de récupérer la clé privée."
        exit 1
    fi

    cd - || exit

    echo "=== Génération du fichier d'inventaire Ansible ==="
    echo "$PRIVATE_KEY" > "$PRIVATE_KEY_FILE"
    chmod 400 "$PRIVATE_KEY_FILE"

    if [ -f "$TERRAFORM_DIR/inventory.txt" ]; then
        mv "$TERRAFORM_DIR/inventory.txt" "$INVENTORY_FILE"
        cat "$INVENTORY_FILE"
    else
        echo "Erreur : Le fichier d'inventaire Terraform n'a pas été généré."
        exit 1
    fi
}

run_ansible() {
    echo "=== Exécution du playbook Ansible ==="
    cd "$ANSIBLE_DIR" || exit
    ansible-playbook -i inventory.txt playbook.yml
    cd - || exit
}

main() {
    echo "=== Déploiement de l'infrastructure et configuration ==="
    run_terraform
    run_ansible
    echo "=== Déploiement terminé avec succès ==="
}

main