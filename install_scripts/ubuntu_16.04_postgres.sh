#-------------------------------------------------------------------------------------
#	Author: Abrom Douglas III
#	email: scripts[at]gh0stface.com
#	Description: This is a single deployment script to launch a microservice API gateway using Kong
#	References: https://konghq.com/ & https://github.com/Kong/kong & 
#-------------------------------------------------------------------------------------	
	
	# get core system updated & additional components
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install netcat openssl libpcre3 dnsmasq procps perl

	# install postgresql & php based admin gui & prep DB for installation. ** NOTE: you should create the kongserver DB account with a stronger password
sudo apt-get -y install postgresql postgresql-contrib phppgadmin
sudo -i -u postgres

psql
CREATE USER kongserver; CREATE DATABASE kong OWNER kongserver;
ALTER USER kongserver WITH password 'kongserver';

	# Install latest version of Kong
cd 
sudo mkdir ./kong
wget https://bintray.com/kong/kong-community-edition-deb/download_file?file_path=dists/kong-community-edition-0.13.1.xenial.all.deb kong-community-edition-0.13.1.xenial.all.deb
sudo kong-community-edition-0.13.1.xenial.all.deb
sudo bash -c "echo -e 'pg_user = kongserver\npg_password = kongserver\npg_database = kong' > /etc/kong.conf"
kong start -vv

	# configure Kong to run at bootup
sudo apt-get install upstart upstart-sysv
sudo update-initramfs -u

	# remember the location of this script
bash -c "echo -e 'kong start -vv' > start.sh"
chmod +x start.sh
mkdir ~/.config

	# Create /etc/init/kong.conf with following content
```sh
start on runlevel [2345]
stop on shutdown

script
    bash $(pwd)/start.sh
end script

pre-start script  
    echo "[`date`] Starting Kong Server" >> /var/log/kong.log
end script

pre-stop script  
    echo "[`date`] Stopping Kong Server" >> /var/log/kong.log
end script
```

	# install the npm package manager
sudo apt-get install npm
sudo npm install -g n@latest
sudo n stable

	# install kong dashboard
sudo npm install -g kong-dashboard

	# Start Kong Dashboard
kong-dashboard start

	# To start Kong Dashboard on a custom port
kong-dashboard start -p 8001

	# To start Kong Dashboard with basic auth
kong-dashboard start -a user=password
