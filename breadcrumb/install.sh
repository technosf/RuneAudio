#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=brea

. /srv/http/addonstitle.sh

installstart $@

getuninstall

wgetnc https://github.com/rern/RuneAudio/raw/master/breadcrumb/breadcrumb.css -P /srv/http/assets/css
wgetnc https://github.com/rern/RuneAudio/raw/master/breadcrumb/breadcrumb.js -P /srv/http/assets/js
chown http:http /srv/http/assets/{css/breadcrumb.css,js/breadcrumb.js}

echo -e "$bar Modify files ..."
file=/srv/http/app/templates/header.php
echo $file
sed -i $'/runeui.css/ a\
    <link rel="stylesheet" href="<?=$this->asset(\'/css/breadcrumb.css\')?>">
' $file

file=/srv/http/app/templates/footer.php
echo $file
echo '<script src="<?=$this->asset('"'"'/js/breadcrumb.js'"'"')?>"></script>' >> $file

file=/srv/http/app/templates/playback.php
echo $file
sed -i -e '/id="db-currentpath"/ {N;N; s/^/<!--brea/; s/$/brea-->/}
' -e '/id="db-level-up"/ {
s/^/<!--brea/
s/$/brea-->/
i\
            <div id="db-currentpath" class="hide">\
                <i id="db-home" class="fa fa-folder-open"></i> <span>Home</span>\
                <i id="db-up" class="fa fa-arrow-left"></i>\
				<i id="db-webradio-add" class="fa fa-plus hide"></i>\
            </div>
}
' $file

installfinish $@
