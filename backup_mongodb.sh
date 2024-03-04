#!/bin/bash

# Load environment variables from .env file
if [[ -f .env ]]; then
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

# MongoDB Docker Container Name
DOCKER_CONTAINER_NAME="mongodb"

# Ensure backup directory exists
mkdir -p ${BACKUP_DIR}

# Timestamp for Backup
TIMESTAMP=$(date +%Y%m%d)

# Backup Command
docker exec ${DOCKER_CONTAINER_NAME} mongodump \
  --host=${MONGO_HOST} \
  --port=${MONGO_PORT} \
  --username=${MONGO_USERNAME} \
  --password=${MONGO_PASSWORD} \
  --out=/tmp/mongodump-${TIMESTAMP}

# Copy Backup from Container to Host
docker cp ${DOCKER_CONTAINER_NAME}:/tmp/mongodump-${TIMESTAMP} ${BACKUP_DIR}

# Clean up temporary backup files inside the container
docker exec -it ${DOCKER_CONTAINER_NAME} rm -rf /tmp/mongodump-${TIMESTAMP}

echo "Backup completed successfully. The backup is stored in ${BACKUP_DIR}/mongodump-${TIMESTAMP}"


# Send Notification to Ntfy
curl -H "Tags: package, MongoDB, Daily Backup" -H "X-Title: MongoDB Daily Backup" -d "Backup completed successfully. The backup is stored in ${BACKUP_DIR}/mongodump-${TIMESTAMP}" https://ntfy.monnyka.top/server
