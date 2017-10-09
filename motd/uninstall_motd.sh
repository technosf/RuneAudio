#!/bin/bash

alias=motd

. /srv/http/addonstitle.sh

uninstallstart $1

echo -e "$bar Restore files ..."

mv -fv /etc/motd{.original,}
rm -v /etc/motd.logo /etc/profile.d/motd.sh

file=/etc/bash.bashrc
echo $file
sed -i -e '/^color=/, /^PS1=\x27/ d
' -e '/^#PS1=/ s/^#//
' $file

uninstallfinish $1

[[ $1 != u ]] && title -nt "$info Relogin to see original motd."
