#!/bin/bash
echo "#########################################################################################################################################"
echo "################################################ Installing APACHE ######################################################################"
echo "#########################################################################################################################################"
sudo apt-get install apache2 -y 
echo "#########################################################################################################################################"
echo "################################################## Instaling PHP ########################################################################"
echo "#########################################################################################################################################"

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Type the version of PHP that you want to install (ex: 7.2)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
read phpVersion

sudo add-apt-repository ppa:ondrej/php  -y 
sudo apt-get install php$phpVersion -y 
sudo apt-get update 
sudo apt-get install php$phpVersion-imac
sudo apt-get install php$phpVersion-curl -y
sudo apt-get install php$phpVersion-mysql -y
sudo apt-get install php$phpVersion-mbstring -y
sudo apt-get install php$phpVersion-bcmath -y
sudo apt-get install php$phpVersion-simplexml -y
sudo apt-get install php$phpVersion-imagick -y
sudo apt-get install php$phpVersion-intl -y
sudo apt-get install php$phpVersion-zip -y
sudo apt-get install php$phpVersion-gd -y
sudo apt-get install unzip -y
sudo apt-get install curl -y
sudo apt-get install openssl -y
sudo a2enmod rewrite

echo "#########################################################################################################################################"
echo "############################################### Instaling Componser #####################################################################"
echo "#########################################################################################################################################"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo service apache2 restart
echo "#########################################################################################################################################"
echo "############################################### Generating SSH Key ######################################################################"
echo "#########################################################################################################################################"
echo ""
echo ""
ssh-keygen
cat ~/.ssh/id_rsa.pub
echo "#########################################################################################################################################"
echo "###################################### YOU NEED COPY THE KEY AND SAVE IT IN GITHUB ######################################################"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  TYPE 'YES' IF YOU DID THAT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
read answer
rm -rf /var/www/*
echo "#########################################################################################################################################"
echo "########################################### Cloning the repository ######################################################################"
echo "#########################################################################################################################################"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  Type the repository (ex: git@github.com:project/site.git) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
read gitRepository
cd /var/www
git init  
git remote add origin $gitRepository
git pull origin master 
echo "#########################################################################################################################################"
echo "################################################# Composer install ######################################################################"
echo "#########################################################################################################################################"

sudo composer install --ignore-platform-reqs
sudo chmod -R 777 bootstrap/cache
sudo chmod -R 777  /var/www/storage/logs
sudo chmod -R 777 storage


curl -O https://developer-files.nyc3.digitaloceanspaces.com/ubunto/virtualhost.txt
sudo  mv virtualhost.txt /etc/apache2/sites-available/000-default.conf

curl -O https://developer-files.nyc3.digitaloceanspaces.com/ubunto/apache2.txt
sudo  mv apache2.txt /etc/apache2/apache2.conf

curl -O https://developer-files.nyc3.digitaloceanspaces.com/ubunto/env_example.txt
sudo  mv env_example.txt .env

sudo service apache2 restart

php artisan key:generate
echo "#########################################################################################################################################"
echo "#####################################################  DONE  ############################################################################"
echo "#########################################################################################################################################"



