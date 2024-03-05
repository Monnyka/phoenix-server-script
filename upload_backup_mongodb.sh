#!/bin/bash

# Load environment variables from .env file
if [[ -f .env ]]; then
    export $(cat .env | grep -v '#' | xargs)
fi

echo "Uploading files to SFTP server..."

# Use sftp with SSH key authentication
sftp -o "StrictHostKeyChecking no" $USERNAME@$SERVER_ADDRESS <<EOF
cd $REMOTE_PATH
put -r $LOCAL_DIR/*
exit
EOF

# Check the exit code of sftp
if [ $? -eq 0 ]; then
  echo "Files uploaded successfully."
else
  echo "File upload failed. Check the error message above for details."
fi

