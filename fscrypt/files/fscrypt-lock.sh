#!/bin/bash

# /usr/local/bin/fscrypt-lock.sh

DIRS=(
  "/path/to/encrypt/dir/secret1"
  "/path/to/encrypt/dir/secret2"
  "/path/to/encrypt/dir/secret3"
)

for dir in "${DIRS[@]}"; do
  /usr/bin/fscrypt lock "$dir"
done