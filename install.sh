#!/bin/bash
set -e

echo "=== Updating packages ==="
sudo apt-get update -y
sudo apt-get upgrade -y

echo "=== Installing base dependencies ==="
sudo apt-get install -y curl wget git jq python3 python3-pip python3-setuptools build-essential libssl-dev libffi-dev libldns-dev libgmp-dev zlib1g-dev ruby-full libxml2 libxml2-dev libxslt1-dev ruby-dev nmap awscli chromium-browser

# Install Go
if ! command -v go &>/dev/null; then
    echo "Installing Go"
    wget https://go.dev/dl/go1.20.7.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.20.7.linux-amd64.tar.gz
    echo "export GOROOT=/usr/local/go" >> ~/.bashrc
    echo "export GOPATH=\$HOME/go" >> ~/.bashrc
    echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.bashrc
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

echo "=== Creating tools directory ==="
mkdir -p ~/tools
cd ~/tools

echo "=== Cloning and setting up tools ==="

git clone https://github.com/nahamsec/recon_profile.git
cat recon_profile/bash_profile >> ~/.bashrc

git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r && pip3 install -r requirements.txt && cd ..

git clone https://github.com/sqlmapproject/sqlmap.git

git clone https://github.com/maurosoria/dirsearch.git

git clone https://github.com/blechschmidt/massdns.git
cd massdns && make && cd ..

git clone https://github.com/yassineaboukir/asnlookup.git
cd asnlookup && pip3 install -r requirements.txt && cd ..

git clone https://github.com/guelfoweb/knock.git

git clone https://github.com/tomnomnom/httprobe.git
go install github.com/tomnomnom/httprobe@latest

go install github.com/tomnomnom/unfurl@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/michenriksen/aquatone@latest

git clone https://github.com/nahamsec/JSParser.git
cd JSParser && sudo python3 setup.py install && cd ..

git clone https://github.com/nahamsec/lazys3.git
git clone https://github.com/jobertabma/virtual-host-discovery.git
git clone https://github.com/nahamsec/crtndstry.git
git clone https://github.com/danielmiessler/SecLists.git

cd SecLists/Discovery/DNS
cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
cd ~/tools

echo "=== Done. Tools installed to ~/tools ==="
echo "Run 'source ~/.bashrc' or restart your shell."
