#!/bin/bash
echo "Script Instalação Docker em maquinas ubuntu"
echo "Feito por Mateus Welter"
# Update no repositório ubuntu
sudo apt-get update

# Instala as depencências necessárias para o Download do Docker
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adiciona o repositório do Docker ao repositório Local ubuntu
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update no repositório ubuntu
sudo apt-get update

# Instala o Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo apt-get install -y docker-compose

echo "Instalação Concluída!"
echo "Verifique a instalação executando o comando: docker ps"
