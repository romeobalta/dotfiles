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

tmux-sessionizer() {
    # list of directories to search for
    dirs=(
        ~
    )

    # list of extra dirs
    extra_dirs=(
        # nested dirs
        ~/personal/baremetal
        ~/personal/tutorials
    )

    # for each extra dir, check if it exists and add it to the list
    for dir in "${extra_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            dirs+=("$dir")
        fi
    done

    # check if ~/projects/_archived exists and add it to the list
    if [[ -d ~/projects/_archived ]]; then
        dirs+=(~/projects/_archived)
    fi

    # check if ~/personal exists and add it to the list
    if [[ -d ~/personal ]]; then
        dirs+=(~/personal)
    fi

    # check if ~/work exists and add it to the list
    if [[ -d ~/work ]]; then
        dirs+=(~/work)
    fi

    # check if ~/soft exists and add it to the list
    if [[ -d ~/soft ]]; then
        dirs+=(~/soft)
    fi

    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(find "${dirs[@]}" -mindepth 1 -maxdepth 1 -type d | fzf)
    fi

    if [[ -z $selected ]]; then
        return 0
        # exit 0
    fi

    selected_name=$(basename "$selected" | tr . _)
    tmux_running=$(pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s "$selected_name" -c "$selected"
        return 0
        # exit 0
    fi

    if ! tmux has-session -t="$selected_name" 2>/dev/null; then
        tmux new-session -ds "$selected_name" -c "$selected"
    fi

    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$selected_name"
        return 0
        # exit 0
    fi

    tmux switch-client -t "$selected_name"
}
zle -N tmux-sessionizer 

activate-zig-dev() {
    if [ -d "$ZIG_DEV_DIR" ]; then
        # Remove stable zig from PATH if present
        export PATH=$(echo "$PATH" | sed "s|$ZIG_DIR:||g" | sed "s|:$ZIG_DIR||g")
        # Add dev zig to PATH
        case ":$PATH:" in
            *":$ZIG_DEV_DIR:"*) ;;
            *) export PATH="$ZIG_DEV_DIR:$PATH" ;;
        esac
        echo "Switched to development Zig: $(which zig)"
    else
        echo "Development Zig directory not found: $ZIG_DEV_DIR"
    fi
}

# Function to switch back to stable zig
activate-zig-stable() {
    if [ -d "$ZIG_DIR" ]; then
        # Remove dev zig from PATH if present
        export PATH=$(echo "$PATH" | sed "s|$ZIG_DEV_DIR:||g" | sed "s|:$ZIG_DEV_DIR||g")
        # Add stable zig to PATH
        case ":$PATH:" in
            *":$ZIG_DIR:"*) ;;
            *) export PATH="$ZIG_DIR:$PATH" ;;
        esac
        echo "Switched to stable Zig: $(which zig)"
    else
        echo "Stable Zig directory not found: $ZIG_DIR"
    fi
}
