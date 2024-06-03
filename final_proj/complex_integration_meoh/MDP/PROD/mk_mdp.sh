#!/bin/bash

# Input file
input_file="prod.00.mdp"

# Loop from 1 to 29 to create new files and modify the init-lambda-state
for i in {1..29}; do
  # New file name
  new_file=$(printf "prod.%02d.mdp" $i)

  # Copy the original file to the new file
  cp "$input_file" "$new_file"

  # Update the init-lambda-state in the new file
  sed -i "s/init-lambda-state[[:space:]]*=[[:space:]]*0/init-lambda-state        = $i/" "$new_file"
done

echo "Files generated successfully."