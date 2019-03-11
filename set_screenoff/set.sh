#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Change screen off duration ..."

xset s $(( 1 * 60 )) 0

(( $1 == 0 )) && min=disabled || min=$1

title -nt "$info Notification duration changed to $( tcolor $min ) minutes"
