#!/usr/bin/env bash

BASE_DIR=$(dirname "$(realpath "$0")")
cd "$BASE_DIR"
for dir in */; do
    abs_path=$(realpath "$dir") # Get the absolute path
    if [ -f "$abs_path/docker-compose.yaml" ] || [ -f "$abs_path/docker-compose.yml" ]; then
        echo "Stopping docker-compose in $abs_path"
        (cd "$abs_path" && podman compose down)
    fi
done
