#!/bin/bash

# Digital Ocean Deployment Script for Sass Factory
# This script assumes you have SSH access to your Digital Ocean Droplet

# Configuration
DROPLET_IP="your-droplet-ip"
SSH_USER="root"
DOMAIN="yourdomain.com"
REPO_URL="https://github.com/yourusername/sass-factory.git"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display help
show_help() {
  echo -e "${YELLOW}Digital Ocean Deployment Script for Sass Factory${NC}"
  echo ""
  echo "Usage: ./deploy-digitalocean.sh [command]"
  echo ""
  echo "Commands:"
  echo "  setup     - Initial setup of the Droplet"
  echo "  deploy    - Deploy the latest code to the Droplet"
  echo "  ssl       - Set up SSL with Let's Encrypt"
  echo "  help      - Show this help message"
  echo ""
  echo "Before running this script, update the configuration variables at the top of the script."
}

# Check if required variables are set
if [ "$DROPLET_IP" = "your-droplet-ip" ] || [ "$DOMAIN" = "yourdomain.com" ] || [ "$REPO_URL" = "https://github.com/yourusername/sass-factory.git" ]; then
  echo -e "${RED}Error: Please update the configuration variables at the top of the script.${NC}"
  exit 1
fi

# Initial setup of the Droplet
setup_droplet() {
  echo -e "${YELLOW}Setting up the Droplet...${NC}"
  
  # Install required packages
  ssh $SSH_USER@$DROPLET_IP "sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl software-properties-common nginx"
  
  # Install Docker
  ssh $SSH_USER@$DROPLET_IP "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
  ssh $SSH_USER@$DROPLET_IP "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\""
  ssh $SSH_USER@$DROPLET_IP "sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin"
  
  # Add user to docker group
  ssh $SSH_USER@$DROPLET_IP "sudo usermod -aG docker $SSH_USER"
  
  # Clone repository
  ssh $SSH_USER@$DROPLET_IP "mkdir -p /opt/sass-factory && cd /opt/sass-factory && git clone $REPO_URL ."
  
  # Set up Nginx
  scp nginx.conf $SSH_USER@$DROPLET_IP:/tmp/nginx.conf
  ssh $SSH_USER@$DROPLET_IP "sudo sed -i 's/yourdomain.com/$DOMAIN/g' /tmp/nginx.conf"
  ssh $SSH_USER@$DROPLET_IP "sudo mv /tmp/nginx.conf /etc/nginx/sites-available/sass-factory"
  ssh $SSH_USER@$DROPLET_IP "sudo ln -sf /etc/nginx/sites-available/sass-factory /etc/nginx/sites-enabled/"
  ssh $SSH_USER@$DROPLET_IP "sudo rm -f /etc/nginx/sites-enabled/default"
  ssh $SSH_USER@$DROPLET_IP "sudo nginx -t && sudo systemctl restart nginx"
  
  echo -e "${GREEN}Droplet setup complete!${NC}"
  echo -e "${YELLOW}Please log out and log back in to apply the Docker group changes.${NC}"
  echo -e "${YELLOW}Then run './deploy-digitalocean.sh deploy' to deploy the application.${NC}"
}

# Deploy the latest code to the Droplet
deploy_app() {
  echo -e "${YELLOW}Deploying the application...${NC}"
  
  # Pull latest code
  ssh $SSH_USER@$DROPLET_IP "cd /opt/sass-factory && git pull"
  
  # Build and run Docker container
  ssh $SSH_USER@$DROPLET_IP "cd /opt/sass-factory && docker-compose down && docker-compose build && docker-compose up -d"
  
  echo -e "${GREEN}Deployment complete!${NC}"
  echo -e "${GREEN}Your application should now be running at http://$DOMAIN${NC}"
}

# Set up SSL with Let's Encrypt
setup_ssl() {
  echo -e "${YELLOW}Setting up SSL with Let's Encrypt...${NC}"
  
  # Install Certbot
  ssh $SSH_USER@$DROPLET_IP "sudo apt update && sudo apt install -y certbot python3-certbot-nginx"
  
  # Obtain SSL certificate
  ssh $SSH_USER@$DROPLET_IP "sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN"
  
  echo -e "${GREEN}SSL setup complete!${NC}"
  echo -e "${GREEN}Your application should now be accessible at https://$DOMAIN${NC}"
}

# Process commands
case "$1" in
  setup)
    setup_droplet
    ;;
  deploy)
    deploy_app
    ;;
  ssl)
    setup_ssl
    ;;
  help|*)
    show_help
    ;;
esac 