#!/bin/bash

# Set up a unique builder name
BUILDER_NAME="mybuilder"

# Create a new builder instance if it doesn't exist
docker buildx inspect $BUILDER_NAME &> /dev/null
if [ $? -ne 0 ]; then
    echo "Creating a new builder instance..."
    docker buildx create --name $BUILDER_NAME --use
fi

# Get the current Git branch name (if on a branch)
GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)

# Get the closest Git tag (if on a tagged commit)
GIT_TAG=$(git describe --tags --abbrev=0 --exact-match 2>/dev/null)

# If on a branch, use branch name, else use the tag, and if not available, use "latest"
if [ -n "$GIT_BRANCH" ]; then
    TAG_NAME="$GIT_BRANCH"
else
    TAG_NAME="latest"
fi

# Get the short Git commit hash
GIT_COMMIT_SHORT=$(git rev-parse --short HEAD)

# Add the short commit hash to the TAG_NAME
TAG_NAME="$TAG_NAME-$GIT_COMMIT_SHORT"

# Build the Docker image for the specified platforms
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/stuwilli/bulma-themes:$TAG_NAME -t ghcr.io/stuwilli/bulma-themes:latest .

# Push the Docker image to GitHub Container Registry
docker buildx build --platform linux/amd64,linux/arm64 --push -t ghcr.io/stuwilli/bulma-themes:$TAG_NAME -t ghcr.io/stuwilli/bulma-themes:latest .

# Clean up the builder instance
docker buildx rm $BUILDER_NAME

echo "Docker image built and pushed successfully with tag: $TAG_NAME"