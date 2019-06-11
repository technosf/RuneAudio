$!/bin/bash

rm $0

. /srv/http/addonstitle.sh

timestart

title -l '=' "$bar Install SSL Certicicate ..."

rankmirrors

pacman -S --needed --noconfirm certbot certbot-nginx python-setuptools python-six python-appdirs python-pyparsing

certbot --nginx

timestop

title -nt "$bar SSL Certicicate installed successfully."
