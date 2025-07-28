# copy_folders.sh

Copies folders from a source directory to a target directory. Only folders that do not exist in the target directory are copied.

## Usage

```bash
./copy_folders.sh /path/to/source_folder /path/to/target_folder [num_folders]
```

### Arguments

- `source_folder`: The directory to copy folders from.
- `target_folder`: The directory to copy folders to.
- `num_folders` (optional): The number of folders to copy in each batch. Defaults to 5 if not provided.

## Notes

- Handles folder names with spaces and special characters safely.
- Requires bash shell.

## Acknowledgments

This script was created with assistance from the Perplexity AI assistant.
Many thanks for the support in writing and refining this script.
