#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
reset=`tput sgr0`

echo "${yellow}Starting...${reset}"
echo ""

echo "${green}[1/8] Installing APACHE${reset}"
echo ""
sudo apt-get update
sudo apt-get install apache2 -y 

echo "${green}[2/8] Instaling PHP${reset}"
echo ""
echo "${yellow}[QUESTION] Type the version of PHP that you want to install:${reset}"
echo ""
read phpVersion
echo ""
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

echo ""
echo "${green}[3/8] Instaling Componser${reset}"
echo ""
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo service apache2 restart

echo ""
echo "${green}[4/8] Generating SSH Key${reset}"
ssh-keygen
echo ""
cat ~/.ssh/id_rsa.pub
echo ""
echo "${blue}[ACTION] Copy the Key and Add in project at Github${reset}"
echo "${yellow}[QUESTION] Type 'YES' if you did that:${reset}"
read answer
rm -rf /var/www/*

echo ""
echo "${green}[5/8] Cloning the repository${reset}"
echo ""
echo "${yellow}[QUESTION] Type the repository:${reset}"
read gitRepository
cd /var/www
git init  
git remote add origin $gitRepository
git pull origin master 

echo ""
echo "${green}[6/8] Project Composer install${reset}"
echo ""
sudo composer install --ignore-platform-reqs
sudo chmod -R 777 bootstrap/cache
sudo chmod -R 777  /var/www/storage/logs
sudo chmod -R 777 storage

echo ""
echo "${green}[7/8] Update the files of Apache${reset}"
echo ""
curl -O https://raw.githubusercontent.com/luucasfzs/ubunto-20-laravel/master/files/virtualhost.txt
sudo  mv virtualhost.txt /etc/apache2/sites-available/000-default.conf
curl -O https://raw.githubusercontent.com/luucasfzs/ubunto-20-laravel/master/files/apache2.txt
sudo  mv apache2.txt /etc/apache2/apache2.conf
sudo service apache2 restart

echo ""
echo "${green}[8/8] Instaling NODE${reset}"
echo "${yellow}[QUESTION] Type the version of NODE that you want to install:${reset}"
echo ""
read nodeVersion
curl -sL https://deb.nodesource.com/setup_$nodeVersion.x | sudo bash -
sudo apt -y install nodejs
sudo npm install
sudo npm run prod

echo ""
echo "${green}Finish${reset}"