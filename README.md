# Sass Factory

A Progressive Web App built with SvelteKit and Tailwind CSS.

## Features

- Progressive Web App (PWA) with offline capabilities
- Responsive design with Tailwind CSS
- Modern UI with beautiful components
- Fast and secure

## Local Development

### Prerequisites

- Node.js (v18 or later)
- pnpm (v8 or later)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/sass-factory.git
   cd sass-factory
   ```

2. Install dependencies:

   ```bash
   pnpm install
   ```

3. Start the development server:

   ```bash
   pnpm dev
   ```

4. Open your browser and navigate to `http://localhost:5173`

## Docker Deployment

### Prerequisites

- Docker
- Docker Compose

### Using Docker Scripts

We've provided a helper script to make Docker operations easier:

```bash
# Make the script executable (if needed)
chmod +x docker-scripts.sh

# Build the Docker image
./docker-scripts.sh build

# Run the Docker container
./docker-scripts.sh run

# View logs
./docker-scripts.sh logs

# Stop the container
./docker-scripts.sh stop

# Clean up Docker resources
./docker-scripts.sh clean
```

### Manual Docker Commands

If you prefer to run Docker commands manually:

```bash
# Build the Docker image
docker-compose build

# Run the Docker container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

The application will be available at `http://localhost:3000` when running in Docker.

## Digital Ocean Deployment

### Option 1: App Platform

1. Create a Digital Ocean account if you don't have one
2. Go to the App Platform section
3. Click "Create App"
4. Connect your GitHub repository
5. Select the branch to deploy
6. Configure the app:
   - Build Command: `pnpm install && pnpm build`
   - Run Command: `node build`
   - Environment: Node.js
7. Click "Launch App"

### Option 2: Droplet with Docker

1. Create a Digital Ocean Droplet (Ubuntu 22.04 LTS)
2. SSH into your Droplet
3. Install Docker and Docker Compose:
   ```bash
   sudo apt update
   sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
   sudo apt update
   sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
   sudo usermod -aG docker $USER
   ```
4. Log out and log back in to apply the group changes
5. Clone your repository:
   ```bash
   git clone https://github.com/yourusername/sass-factory.git
   cd sass-factory
   ```
6. Build and run the Docker container:
   ```bash
   docker-compose up -d
   ```
7. Set up Nginx as a reverse proxy (optional but recommended):
   ```bash
   sudo apt install -y nginx
   sudo nano /etc/nginx/sites-available/sass-factory
   ```
8. Add the following configuration:

   ```nginx
   server {
       listen 80;
       server_name yourdomain.com www.yourdomain.com;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

9. Enable the site and restart Nginx:
   ```bash
   sudo ln -s /etc/nginx/sites-available/sass-factory /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```
10. Set up SSL with Let's Encrypt (optional but recommended):
    ```bash
    sudo apt install -y certbot python3-certbot-nginx
    sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
    ```

## License

MIT
