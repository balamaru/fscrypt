#!/bin/bash

# /usr/local/bin/fscrypt-unlock.sh

KEY="/path/to/key.key"

DIRS=(
  "/path/to/encrypt/dir/secret1"
  "/path/to/encrypt/dir/secret2"
  "/path/to/encrypt/dir/secret3"
)

for dir in "${DIRS[@]}"; do
  /usr/bin/fscrypt unlock "$dir" --key="$KEY"
done