#!/usr/bin/env sh

echo "Install and setup apache+php-fpm"

sudo apt-get install apache2 libapache2-mod-fastcgi

# enable php-fpm
sudo cp ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf.default ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf
sudo a2enmod rewrite actions fastcgi alias

echo "cgi.fix_pathinfo = 1" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
echo 'date.timezone = "Europe/Rome"' >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini

~/.phpenv/versions/$(phpenv version-name)/sbin/php-fpm

# configure apache virtual hosts
sudo cp -f ./tests/setup/apache-vhost.conf /etc/apache2/sites-available/default
sudo sed -e "s#%DOC_ROOT_DIR%#/var/www/PS_${PS_VERSION}#g" --in-place /etc/apache2/sites-available/default

sudo service apache2 restart