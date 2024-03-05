#!/bin/bash

# Load environment variables from .env file
if [[ -f .env ]]; then
    export $(cat .env | grep -v '#' | xargs)
fi

# MongoDB Docker Container Name
DOCKER_CONTAINER_NAME="mongodb"

# Backup Directory
BACKUP_DIR="/backup"

# Choose the specific backup directory to restore from (replace TIMESTAMP accordingly)
DATE=$1  # Replace with the actual timestamp from your backup

# Restore Command
docker exec -it ${DOCKER_CONTAINER_NAME} mongorestore \
  --host=${MONGO_HOST} \
  --port=${MONGO_PORT} \
  --username=${MONGO_USERNAME} \
  --password=${MONGO_PASSWORD} \
  --drop \
  ${BACKUP_DIR}/mongodump-${DATE}

# Check the exit code of mongorestore
if [ $? -eq 0 ]; then
  echo "Restore completed successfully."
else
  echo "Restore failed. Check the error message above for details."
fi

