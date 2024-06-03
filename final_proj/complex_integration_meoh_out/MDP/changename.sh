#!/bin/bash

# Directory containing .mdp files
DIR="/home/f0042vb/CHEM101.6/final_proj/complex_integration/MDP/PROD"

# Loop through all .mdp files in the directory
for file in "$DIR"/*.mdp; do
  # Check if the file has at least 86 lines
  if [ $(wc -l < "$file") -ge 86 ]; then
    # Replace the 86th line if it matches the pattern
    sed -i '86s/couple-moltype\s*=\s*ligand/couple-moltype = ADM/' "$file"
  else
    echo "File $file does not have 86 lines."
  fi
done

echo "Processing complete."