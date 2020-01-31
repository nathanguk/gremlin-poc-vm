#!/bin/bash

#Update Server
apt-get update -y


# Install Apache Webserver
sleep 30
apt-get install -y apache2

# Crete index.html file
echo "<!DOCTYPE html>" > /var/www/html/index.html
echo "<html>" >> /var/www/html/index.html
echo "<head>" >> /var/www/html/index.html
echo '<meta http-equiv="refresh" content="30">' >> /var/www/html/index.html
echo "</head>" >> /var/www/html/index.html
echo "<body><h1>$(hostname)</h1></body>" >> /var/www/html/index.html
echo "</html>" >> /var/www/html/index.html

# Install Transport Https
apt-get install -y apt-transport-https

# Add the Gremlin repo
echo "deb https://deb.gremlin.com/ release non-free" | tee /etc/apt/sources.list.d/gremlin.list

# Import the GPG key
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9CDB294B29A5B1E2E00C24C022E8EF3461A50EF6

# Install Gremlin client and daemon
apt-get update && sudo apt-get install -y gremlin gremlind

# Configure Gremlin Team Configuration
echo "GREMLIN_TEAM_ID=$1" >> /etc/default/gremlind

# Configure Gremlin Identifier
echo "GREMLIN_IDENTIFIER=$(hostname)" >> /etc/default/gremlind

# Download Gremlin Certitificates
sudo wget -O /var/lib/gremlin/gremlin.pub_cert.pem -o ~/wget1.log $3
sudo wget -O /var/lib/gremlin/gremlin.priv_key.pem -o ~/wget2.log $2

# Configure Gremlin Certitifcate Configuration
echo 'GREMLIN_TEAM_CERTIFICATE_OR_FILE="file:///var/lib/gremlin/gremlin.pub_cert.pem"' >> /etc/default/gremlind
echo 'GREMLIN_TEAM_PRIVATE_KEY_OR_FILE="file:///var/lib/gremlin/gremlin.priv_key.pem"' >> /etc/default/gremlind
echo 'GREMLIN_CLIENT_TAGS="application=gremlin-poc,owner=nathan_gaskill,department=octo"' >> /etc/default/gremlind


chown gremlin:gremlin /var/lib/gremlin/gremlin.p*
chmod 600 /var/lib/gremlin/gremlin.p*

# Reload Gremlin Daemon to use new config
sudo systemctl reload gremlind





