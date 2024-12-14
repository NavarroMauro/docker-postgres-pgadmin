#!/bin/bash

set -e

# Stop Docker Compose services
echo "Stopping Docker Compose services..."
docker-compose down -v

# Remove Docker containers if any exist
CONTAINERS=$(docker ps -a -q)
if [ -n "$CONTAINERS" ]; then
  echo "Removing Docker containers..."
  docker rm -f $CONTAINERS || true
else
  echo "No Docker containers to remove."
fi

# Remove Docker volumes if any exist
VOLUMES=$(docker volume ls -q)
if [ -n "$VOLUMES" ]; then
  echo "Removing Docker volumes..."
  docker volume rm $VOLUMES || true
else
  echo "No Docker volumes to remove."
fi

# Remove persistent storage folders
echo "Cleaning persistent storage folders..."
sudo rm -rf ./postgres/conndatos/data/
sudo rm -rf ./postgres/lead_system/data/
sudo rm -rf ./pgadmin/data/

# Remove and recreate persistent storage folders
for folder in ./postgres/conndatos/data/ ./postgres/lead_system/data/ ./pgadmin/data/; do
  if [ -d "$folder" ]; then
    echo "Removing $folder folder..."
    sudo rm -rf "$folder"
    if [ -d "$folder" ]; then
      echo "Failed to remove $folder folder."
    else
      echo "$folder folder removed successfully."
    fi
  else
    echo "$folder folder does not exist."
  fi
  echo "Creating $folder folder..."
  mkdir -p "$folder"
done

echo "Cleanup completed."

# # Start Docker Compose services
# echo "Starting Docker Compose services..."
# docker-compose up -d
# docker ps
# echo "Docker Compose services started successfully."
