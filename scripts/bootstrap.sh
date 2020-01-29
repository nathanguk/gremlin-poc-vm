#!/bin/bash


#Update Server
apt-get update -y
# apt-get upgrade -y

# Install Apache Webserver
apt-get install -y apache2
hostname > /var/www/html/index.html


# Install Unzip
apt-get install -y apt-transport-https


# Add the Gremlin repo
echo "deb https://deb.gremlin.com/ release non-free" | tee /etc/apt/sources.list.d/gremlin.list

# Import the GPG key
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9CDB294B29A5B1E2E00C24C022E8EF3461A50EF6

# Install Gremlin client and daemon
apt-get update && sudo apt-get install -y gremlin gremlind

# Download Gremlin Certitificates
wget -O /var/lib/gremlin/gremlin.priv_key.pem $2
wget -O /var/lib/gremlin/gremlin.pub_key.pem $3

# Configure Gremlin Configuration
echo "GREMLIN_TEAM_ID=$1" >> /etc/default/gremlind
echo 'GREMLIN_TEAM_CERTIFICATE_OR_FILE="file:///var/lib/gremlin/gremlin.pub_cert.pem"' >> /etc/default/gremlind
echo 'GREMLIN_TEAM_PRIVATE_KEY_OR_FILE="file:///var/lib/gremlin/gremlin.priv_key.pem"' >> /etc/default/gremlind

chown gremlin:gremlin /var/lib/gremlin/gremlin.p*
chmod 600 /var/lib/gremlin/gremlin.p*

# Reload Gremlin Daemon to use new config
sudo systemctl reload gremlind





