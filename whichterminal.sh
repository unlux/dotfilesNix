#!/usr/bin/env zsh

# Check if the TERMINAL environment variable is set
if [ -z "$TERMINAL" ]; then
  echo "The TERMINAL environment variable is not set."
  echo "Please set it to 'alacritty' or 'wezterm'."
  exit 1
fi

# Open the corresponding terminal based on the TERMINAL environment variable
case "$TERMINAL" in
  "alacritty")
    if command -v alacritty > /dev/null; then
      alacritty
    else
      echo "Alacritty is not installed."
      exit 1
    fi
    ;;
  "wezterm")
    if command -v wezterm > /dev/null; then
      wezterm
    else
      echo "WezTerm is not installed."
      exit 1
    fi
    ;;
  *)
    echo "Invalid value for TERMINAL environment variable. Please set it to 'alacritty' or 'wezterm'."
    exit 1
    ;;
esac

