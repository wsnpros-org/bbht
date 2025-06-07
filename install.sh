#!/bin/bash
set -e

# Disable pip update notices
export PIP_DISABLE_PIP_VERSION_CHECK=1

echo "=== Updating system packages ==="
sudo apt-get update -y
sudo apt-get upgrade -y

echo "=== Installing base dependencies ==="
sudo apt-get install -y \
  curl wget git jq python3 python3-pip python3-setuptools \
  build-essential libssl-dev libffi-dev libldns-dev libgmp-dev \
  zlib1g-dev ruby-full libxml2 libxml2-dev libxslt1-dev ruby-dev \
  nmap awscli chromium-browser

# Install Go if not already installed
if ! command -v go &>/dev/null; then
  echo "=== Installing Go ==="
  wget https://go.dev/dl/go1.20.7.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go1.20.7.linux-amd64.tar.gz
  echo "export GOROOT=/usr/local/go" >> ~/.bashrc
  echo "export GOPATH=\$HOME/go" >> ~/.bashrc
  echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.bashrc
  export GOROOT=/usr/local/go
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

# Ensure setuptools is available
python3 -m pip install --upgrade pip setuptools

# Helper function
ensure_python_module() {
  python3 -c "import $1" 2>/dev/null || python3 -m pip install $1
}

echo "=== Creating tools directory ==="
mkdir -p ~/tools
cd ~/tools

echo "=== Cloning and setting up tools ==="

# recon_profile
if [ ! -d "recon_profile" ]; then
  git clone https://github.com/nahamsec/recon_profile.git
  cat recon_profile/bash_profile >> ~/.bashrc
else
  echo "recon_profile already exists, skipping..."
fi

# Sublist3r
[ ! -d "Sublist3r" ] && git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r && pip3 install -r requirements.txt && cd ..

# sqlmap
[ ! -d "sqlmap" ] && git clone https://github.com/sqlmapproject/sqlmap.git

# dirsearch
[ ! -d "dirsearch" ] && git clone https://github.com/maurosoria/dirsearch.git

# massdns
[ ! -d "massdns" ] && git clone https://github.com/blechschmidt/massdns.git
cd massdns && make && cd ..

# asnlookup
[ ! -d "asnlookup" ] && git clone https://github.com/yassineaboukir/asnlookup.git
cd asnlookup && pip3 install -r requirements.txt && cd ..

# knock.py
[ ! -d "knock" ] && git clone https://github.com/guelfoweb/knock.git

# httprobe
go install github.com/tomnomnom/httprobe@latest
go install github.com/tomnomnom/unfurl@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/michenriksen/aquatone@latest

# JSParser
[ ! -d "JSParser" ] && git clone https://github.com/nahamsec/JSParser.git
cd JSParser
ensure_python_module setuptools
sudo python3 setup.py install
cd ..

# Misc tools
[ ! -d "lazys3" ] && git clone https://github.com/nahamsec/lazys3.git
[ ! -d "virtual-host-discovery" ] && git clone https://github.com/jobertabma/virtual-host-discovery.git
[ ! -d "crtndstry" ] && git clone https://github.com/nahamsec/crtndstry.git

# SecLists
if [ ! -d "SecLists" ]; then
  git clone https://github.com/danielmiessler/SecLists.git
  cd SecLists/Discovery/DNS
  cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
  cd ~/tools
else
  echo "SecLists already exists, skipping..."
fi

echo "=== DONE ==="
echo "Tools installed in ~/tools"
echo "To apply aliases and functions, run: source ~/.bashrc"
