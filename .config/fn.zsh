# Function to edit the current command buffer in nvim and execute on save
edit-and-run() {
  # Create a temporary file to store the command
  local TMP_FILE=$(mktemp)

  # Write the current command line buffer to the temp file
  # $BUFFER is a special zsh variable holding the current command line
  echo "$BUFFER" >"$TMP_FILE"

  # Open the temp file in nvim. The script will pause here until you close nvim.
  nvim "$TMP_FILE"

  # After nvim closes, read the (potentially modified) command back
  local NEW_CMD=$(<"$TMP_FILE")

  # Clean up the temporary file
  rm -f "$TMP_FILE"

  # Replace the current command buffer with the new command
  BUFFER="$NEW_CMD"

  # Accept the command line to execute it
  zle accept-line
}

zle -N edit-and-run
bindkey '^[e' edit-and-run
