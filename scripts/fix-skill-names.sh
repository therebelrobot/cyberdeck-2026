#!/bin/bash
#
# fix-skill-names.sh
# Converts skill folder names and name: fields to lowercase to comply with naming conventions.
# Naming convention: only lowercase letters (a-z), numbers (0-9), and hyphens (-) allowed.
#
# This script is idempotent - safe to run multiple times.

set -e  # Exit on error

SKILLS_DIR=".roo/skills"

echo "=== Skill Name Fix Script ==="
echo "Scanning for skill folders with uppercase letters in: $SKILLS_DIR"
echo ""

# Check if skills directory exists
if [ ! -d "$SKILLS_DIR" ]; then
    echo "ERROR: Skills directory not found: $SKILLS_DIR"
    exit 1
fi

# Find all directories in skills folder and process those with uppercase letters
find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d | sort | while read -r dir; do
    dirname=$(basename "$dir")
    
    # Check if directory name contains uppercase letters
    if echo "$dirname" | grep -q '[A-Z]'; then
        # Convert to lowercase
        lowercase_name=$(echo "$dirname" | tr '[:upper:]' '[:lower:]')
        parent_dir=$(dirname "$dir")
        old_path="$parent_dir/$dirname"
        new_path="$parent_dir/$lowercase_name"
        
        echo "Processing: $dirname → $lowercase_name"
        
        # Only rename if old and new names are different
        if [ "$dirname" != "$lowercase_name" ]; then
            # On macOS, HFS+/APFS is case-insensitive, so we cannot just rm the lowercase version
            # We need to use a two-step rename: uppercase → temp → lowercase
            temp_name="${lowercase_name}_temp_$$"
            temp_path="$parent_dir/$temp_name"
            
            # First rename: uppercase → temp
            mv "$old_path" "$temp_path"
            echo "  Step 1: $dirname → $temp_name"
            
            # Second rename: temp → lowercase
            mv "$temp_path" "$new_path"
            echo "  Step 2: $temp_name → $lowercase_name"
            
            # Find and update SKILL.md file
            skill_file="$new_path/SKILL.md"
            if [ -f "$skill_file" ]; then
                # Update name: field to lowercase
                if grep -q '^name:.*[A-Z]' "$skill_file"; then
                    sed -i '' "s/^name:.*/name: $lowercase_name/" "$skill_file"
                    echo "  Updated name: field in SKILL.md to: $lowercase_name"
                else
                    echo "  name: field already lowercase or not found"
                fi
            else
                echo "  WARNING: SKILL.md not found at $skill_file"
            fi
        else
            echo "  No folder rename needed"
        fi
    else
        echo "Skipping (no uppercase): $dirname"
    fi
done

echo ""
echo "=== Script Complete ==="
echo "All skill folders and name fields have been normalized to lowercase."