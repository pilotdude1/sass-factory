#!/bin/bash

# Function to display help
show_help() {
  echo "Sass Factory Docker Helper Script"
  echo ""
  echo "Usage: ./docker-scripts.sh [command]"
  echo ""
  echo "Commands:"
  echo "  build     - Build the Docker image"
  echo "  run       - Run the Docker container"
  echo "  stop      - Stop the Docker container"
  echo "  logs      - View Docker container logs"
  echo "  clean     - Remove Docker containers and images"
  echo "  help      - Show this help message"
  echo ""
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  echo "Error: Docker is not installed. Please install Docker first."
  exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
  echo "Error: Docker Compose is not installed. Please install Docker Compose first."
  exit 1
fi

# Process commands
case "$1" in
  build)
    echo "Building Docker image..."
    docker-compose build
    ;;
  run)
    echo "Starting Docker container..."
    docker-compose up -d
    echo "Application is running at http://localhost:3000"
    ;;
  stop)
    echo "Stopping Docker container..."
    docker-compose down
    ;;
  logs)
    echo "Viewing Docker container logs..."
    docker-compose logs -f
    ;;
  clean)
    echo "Cleaning Docker resources..."
    docker-compose down --rmi all
    ;;
  help|*)
    show_help
    ;;
esac 