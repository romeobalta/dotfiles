tmux-sessionizer() {
    # 1. Argument Parsing
    local exit_on_finish=false
    if [[ "$1" == "--exit" ]]; then
        exit_on_finish=true
        shift
    fi

    # 2. Configuration
    # Standard directories to search (children will be listed)
    local search_roots=(
        ~
        ~/personal
        ~/personal/baremetal
        ~/personal/tmp
        ~/personal/tutorials
        ~/soft
        ~/work
    )

    # Worktree parents (children listed, parent itself excluded)
    local worktree_parents=(
        ~/work/n8n
        ~/work/n8n-cloud
        ~/work/ai-assistant-service
        # Add other worktree parent directories here
    )

    # 3. Build Valid Directory List
    local valid_dirs=()
    
    # Add search roots if they exist
    for dir in "${search_roots[@]}"; do
        [[ -d "$dir" ]] && valid_dirs+=("$dir")
    done

    # Add worktree parents if they exist
    local grep_excludes=()
    for dir in "${worktree_parents[@]}"; do
        if [[ -d "$dir" ]]; then
            valid_dirs+=("$dir")
            # We add this to an exclude list so grep removes the parent folder itself
            grep_excludes+=("-e" "$dir")
        fi
    done

    # 4. Select Directory (fd + grep + fzf)
    local selected
    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        # FD OPTIMIZATION:
        # fd . -> search for everything (catch-all pattern)
        # "${valid_dirs[@]}" -> search inside these paths
        # --min-depth 1 --max-depth 1 -> only direct children
        # --type d -> only directories
        # grep -vFx -> Exclude the exact lines matching worktree parents
        selected=$(fd . "${valid_dirs[@]}" --min-depth 1 --max-depth 1 --type d | \
                   sed 's:/*$::' | \
                   grep -vFx "${grep_excludes[@]}" | \
                   fzf)
    fi

    if [[ -z $selected ]]; then
        return 0
    fi

    # 5. Determine Session Name (Zsh Native)
    # ${selected:t} gets the tail (basename)
    local selected_name="${selected:t}"
    
    # Replace dots and colons with underscores
    selected_name="${selected_name//[. :]/-}"

    # Handle Worktree Naming (prefix with parent folder name)
    for parent in "${worktree_parents[@]}"; do
        if [[ "$selected" == "$parent"/* ]]; then
            selected_name="${parent:t}_${selected_name}"
            break
        fi
    done

    # 6. Unified Tmux Logic
    # Create detached session if it doesn't exist
    if ! tmux has-session -t="$selected_name" 2>/dev/null; then
        tmux new-session -ds "$selected_name" -c "$selected"
    fi

    # Switch (if inside tmux) or Attach (if outside)
    if [[ -n $TMUX ]]; then
        tmux switch-client -t "$selected_name"
    else
        tmux attach-session -t "$selected_name"
    fi

    # 7. Exit if requested
    if [[ $exit_on_finish == true ]]; then
        exit 0
    fi
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

send_with_length() {
  local msg="$1"
  local len=${#msg}  # Get string length in bytes
  {
    printf "\\x$(printf '%02x' $((len & 0xFF)))"
    printf "\\x$(printf '%02x' $(((len >> 8) & 0xFF)))"
    printf "\\x$(printf '%02x' $(((len >> 16) & 0xFF)))"
    printf "\\x$(printf '%02x' $(((len >> 24) & 0xFF)))"
    printf "%s" "$msg"
  } > /tmp/input
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

    claude
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

codex-select() {
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

    codex
}
