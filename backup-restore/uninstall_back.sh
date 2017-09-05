#!/bin/bash

# import heading function
wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

title -l = "$bar Uninstall Backup-Restore update ..."

if [[ ! -e /srv/http/restore.php ]]; then
    echo -e "$info Uninstall Backup-Restore update not found."
    exit
fi

echo -e "$bar Restore files ..."
sed -i -e '\|/run/backup_|,+1 s|^//||
' -e '\|/srv/http/tmp|,/^ \+;/ d
' /srv/http/app/libs/runeaudio.php

sed -i -e 's/id="restore"/method="post"/
' -e 's/type="file" name="filebackup"/type="file"/
' -e '/id="btn-backup-upload"/ s/id="btn-backup-upload"/& name="syscmd" value="restore"/; s/disabled>Restore/type="submit" disabled>Upload/
' /srv/http/app/templates/settings.php

sed -i '/#restore/,/^});/ d' /srv/http/assets/js/runeui.js

sed -i 's/\$("#restore").\+});//' /srv/http/assets/js/runeui.min.js

rm /srv/http/restore.* /etc/sudoers.d/http-backup
rm -r /srv/http/tmp

redis-cli hdel addons back &> /dev/null

title -l = "$bar Backup-Restore update uninstalled successfully."

# clear opcache if run from terminal #######################################
[[ -t 1 ]] && systemctl reload php-fpm

systemctl restart rune_SY_wrk

rm $0
