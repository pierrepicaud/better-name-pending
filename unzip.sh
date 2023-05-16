#!/bin/bash

# how to run: ./unzip.sh file1.zip file2.zip

# Loop over all file names passed as command-line arguments
for file in "$@"; do
  # Extract the base file name without the '.zip' extension
  dir=${file%.zip}

  # Check if the unzipped directory exists
  if [ ! -d "$dir" ]; then
    # Unzip the file if the directory does not exist
    unzip $file -d $dir
    echo "File $file unzipped successfully to $dir"
  else
    echo "Directory $dir already exists. File $file was not unzipped."
  fi
done