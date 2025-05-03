#!/bin/bash

# Get the script's directory (your project root)
BASEDIR=$(dirname "$(readlink -f "$0")")

echo
echo "⚠️  This will delete all contents in mounted Docker data folders:"
echo "   - open-webui/"
echo "   - data/postgres/"
echo "   - caddy/data/"
echo "   - caddy/config/"
echo

read -p "Are you sure you want to continue? (y/N): " confirm
if [[ "$confirm" != [yY] ]]; then
    echo "Aborted."
    exit 1
fi

# List of folders to purge
DIRS=("open-webui" "data/postgres" "caddy/data" "caddy/config")

# List of filenames to preserve (add more as needed)
PRESERVE=(".gitignore" ".gitkeep")

for dir in "${DIRS[@]}"; do
    TARGET="$BASEDIR/$dir"
    if [ -d "$TARGET" ]; then
        echo "Purging $dir ..."
        pushd "$TARGET" > /dev/null
        
        # Find all files and check against preserve list
        find . -type f -maxdepth 1 | while read file; do
            filename=$(basename "$file")
            skip=0
            
            # Check if file should be preserved
            for preserve in "${PRESERVE[@]}"; do
                if [[ "$filename" == "$preserve" ]]; then
                    skip=1
                    break
                fi
            done
            
            # Delete if not in preserve list
            if [ $skip -eq 0 ]; then
                rm -f "$file" 2>/dev/null
            fi
        done
        
        # Delete all subdirectories
        find . -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \; 2>/dev/null
        
        popd > /dev/null
    else
        echo "Skipping $dir (not found)"
    fi
done

echo
echo "✅ Done. Selected data folders have been purged (preserved .gitignore, .gitkeep)."
