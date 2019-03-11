#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Change screen off duration ..."

xset s $(( 1 * 60 )) 0

title -nt "$info Notification duration changed to $1 minutes"
