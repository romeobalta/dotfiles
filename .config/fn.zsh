tmux-sessionizer() {
    local exit_on_finish=false

    if [[ "$1" == "--exit" ]]; then
        exit_on_finish=true
        shift
    fi

    # list of directories to search for
    dirs=(
        ~
    )

    # list of extra dirs
    extra_dirs=(
        # nested dirs
        ~/personal/baremetal
        ~/personal/tutorials
        ~/personal/tmp
    )

    # Directories that contain git worktrees (search their subdirs)
    worktree_parents=(
        ~/work/n8n
        # Add other worktree parent directories here
    )

    # for each extra dir, check if it exists and add it to the list
    for dir in "${extra_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            dirs+=("$dir")
        fi
    done

    for dir in "${worktree_parents[@]}"; do
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
        if [[ $exit_on_finish == true ]]; then
            exit 0
        else
            return 0
        fi
    fi

    selected_name=$(basename "$selected" | tr . _)

    # For worktree directories, you might want to prefix with parent name
    # to avoid collisions (e.g., multiple "master" directories)
    for parent in "${worktree_parents[@]}"; do
        if [[ "$selected" == "$parent"/* ]]; then
            parent_name=$(basename "$parent")
            selected_name="${parent_name}_${selected_name}"
            break
        fi
    done

    tmux_running=$(pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s "$selected_name" -c "$selected"
        if [[ $exit_on_finish == true ]]; then
            exit 0
        else
            return 0
        fi
    fi

    if ! tmux has-session -t="$selected_name" 2>/dev/null; then
        tmux new-session -ds "$selected_name" -c "$selected"
    fi

    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$selected_name"
        if [[ $exit_on_finish == true ]]; then
            exit 0
        else
            return 0
        fi
    fi

    tmux switch-client -t "$selected_name"
}

zig-dev() {
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

    if [ -d "$ZLS_DEV_DIR" ]; then
        # Remove stable zls from PATH if present
        export PATH=$(echo "$PATH" | sed "s|$ZLS_DIR:||g" | sed "s|:$ZLS_DIR||g")
        # Add dev zls to PATH
        case ":$PATH:" in
            *":$ZLS_DEV_DIR:"*) ;;
            *) export PATH="$ZLS_DEV_DIR:$PATH" ;;
        esac

        echo "Switched to development zls: $(which zls)"
    else
        echo "Development zls directory not found: $ZLS_DEV_DIR"
    fi
}

# Function to switch back to stable zig
zig-stable() {
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

    if [ -d "$ZLS_DIR" ]; then
        # Remove dev zls from PATH if present
        export PATH=$(echo "$PATH" | sed "s|$ZLS_DEV_DIR:||g" | sed "s|:$ZLS_DEV_DIR||g")
        # Add stable zls to PATH
        case ":$PATH:" in
            *":$ZLS_DIR:"*) ;;
            *) export PATH="$ZLS_DIR:$PATH" ;;
        esac
        echo "Switched to stable zls: $(which zls)"
    else
        echo "Stable zls directory not found: $ZLS_DIR"
    fi
}

claude-select() {
    local exit_on_finish=false

    if [[ "$1" == "--exit" ]]; then
        exit_on_finish=true
        shift
    fi

    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(fd . --type d | fzf)
    fi

    if [[ $selected ]]; then
        cd "$selected"
    fi

    "$HOME/.claude/local/claude"
}

gemini-select() {
    local exit_on_finish=false

    if [[ "$1" == "--exit" ]]; then
        exit_on_finish=true
        shift
    fi

    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(fd . --type d | fzf)
    fi

    if [[ $selected ]]; then
        cd "$selected"
    fi

    gemini
}

