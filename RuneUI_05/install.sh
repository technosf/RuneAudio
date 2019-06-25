#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Update Default RuneUI ..."

wgetnc https://github.com/gearhead/RuneUI/archive/0.5b.zip
bsdtar xvf 0.5b.zip -C /srv/http
rm 0.5b.zip

/srv/http/command/update_os.php

restartlocalbrowser

reinitsystem

title -nt "$bar Default RuneUI updated successfully."
