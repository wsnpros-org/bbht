#!/bin/bash

# --- Recon Tools to Check ---
tools=(
  "amass"
  "subfinder"
  "httpx"
  "nuclei"
  "nmap"
  "curl"
  "wget"
  "unzip"
  "git"
)

echo "🔍 Checking installed recon tools..."
for tool in "${tools[@]}"; do
  if command -v $tool &> /dev/null; then
    echo "✅ $tool is installed at $(command -v $tool)"
  else
    echo "❌ $tool is NOT installed"
  fi
done

echo ""
echo -e "\n📌 Current shell aliases:\n"
if [ -f ~/.bash_aliases ]; then
    echo "🗂 Loaded from ~/.bash_aliases:"
    cat ~/.bash_aliases
else
    echo "⚠️ No ~/.bash_aliases file found"
fi

# Show currently active aliases (interactive session only)
echo -e "\n📜 Active aliases in this session:"
alias


echo ""
echo -e "\n📂 PATH directories:"
echo "$PATH" | tr ':' '\n' | awk '!seen[$0]++'

echo ""
echo "🎯 Default shell: $SHELL"
