#!/bin/bash

# Load environment variables from .env file
if [[ -f .env ]]; then
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

# Backup MongoDB
docker exec -it mongodb mongodump --uri="mongodb://${MONGO_USERNAME}:${MONGO_PA>

# Copy to host
docker cp mongodb:/tmp/mongodb-backup /home/nyka/tmp/mongodb-backup

# Compress
tar -czvf /home/nyka/tmp/mongodb-backup.tar.gz /home/nyka/tmp/mongodb-backup

# Upload to R2
rclone copy /home/nyka/tmp/mongodb-backup.tar.gz r2:nykaserver/mongodb-backups/

# Cleanup
rm -rf /home/nyka/tmp/mongodb-backup /home/nyka/tmp/mongodb-backup.tar.gz