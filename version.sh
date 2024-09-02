#!/bin/bash

# Get the current version from the package.json file
current_version=$(jq -r '.version' package.json)

echo "Current version: $current_version"

# Prompt the user for the type of version bump
echo "Select the type of version bump:"
echo "1) Major"
echo "2) Minor"
echo "3) Patch"
read -p "Enter your choice [1-3]: " version_type

# Determine the new version based on the user's choice
case $version_type in
    1)
        new_version=$(npm version major --no-git-tag-version)
        ;;
    2)
        new_version=$(npm version minor --no-git-tag-version)
        ;;
    3)
        new_version=$(npm version patch --no-git-tag-version)
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "New version: $new_version"

# Update the version in package.json
jq --arg new_version "$new_version" '.version = $new_version' package.json > tmp.json && mv tmp.json package.json

# Optional: Commit the version bump
git add package.json
git commit -m "Bump version to $new_version"

# Optional: Tag the new version
git tag "v$new_version"
git push origin --tags
