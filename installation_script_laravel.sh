#!/bin/bash

echo "Starting..."

echo "[1/8] Installing APACHE"
sudo apt-get install apache2 -y 

echo "[2/8] Instaling PHP"
echo "[QUESTION] Type the version of PHP that you want to install (ex: 7.2):"
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


echo "[3/8] Instaling Componser"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo service apache2 restart
echo "[4/8] Generating SSH Key"
echo ""
echo ""
ssh-keygen
cat ~/.ssh/id_rsa.pub
echo "[ACTION] Copy the Key and Add in project at Github"
echo "[QUESTION] Type 'YES' if you did that:"
read answer
rm -rf /var/www/*
echo "[5/8] Cloning the repository"
echo "[QUESTION] Type the repository (ex: git@github.com:project/site.git):"
read gitRepository
cd /var/www
git init  
git remote add origin $gitRepository
git pull origin master 
echo "[6/8] Project Composer install"

sudo composer install --ignore-platform-reqs
sudo chmod -R 777 bootstrap/cache
sudo chmod -R 777  /var/www/storage/logs
sudo chmod -R 777 storage

echo "[7/8] Updating the files of Apache"
curl -O https://raw.githubusercontent.com/luucasfzs/ubunto-20-laravel/master/installation_script_laravel.sh && sh installation_script_laravel.sh
curl -O https://raw.githubusercontent.com/luucasfzs/ubunto-20-laravel/master/files/apache2.txt
sudo  mv apache2.txt /etc/apache2/apache2.conf
curl -O https://raw.githubusercontent.com/luucasfzs/ubunto-20-laravel/master/logs/env_example.txt
sudo  mv env_example.txt .env


echo "[8/8] Instaling NODE"
echo "[QUESTION] Type the version of NODE that you want to install (ex: 14):"
read nodeVersion
curl -sL https://deb.nodesource.com/setup_$nodeVersion.x | sudo bash -
sudo apt -y install nodejs
sudo npm install
sudo npm run prod

sudo service apache2 restart
php artisan key:generate
echo "Done"



