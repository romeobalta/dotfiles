batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

# watch processes on a port
watchport() {
  if [ -z "$1" ]; then
    echo "Usage: watchport <port-number>"
    return 1
  fi

  watch -n 1 lsof -i :$1
}

# kill a go process on a port (hence why main is used)
killgo() {
  if [ -z "$1" ]; then
    echo "Usage: killgo <port-number>"
    return 1
  fi

  lsof -i :$1 | awk '$1 == "main"{print $2}' | xargs kill -9
}

