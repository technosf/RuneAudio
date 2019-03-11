#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Change screen off duration ..."

export DISPLAY=:0
xset s $(( $1 * 60 )) 0

(( $1 == 0 )) && min=disabled || min="$1 minutes"

title -nt "$info Screen off timeout changed to $( tcolor "$min" )"
