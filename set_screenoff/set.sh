#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Set screen off timeout ..."

export DISPLAY=:0
xset s $(( $1 * 60 )) 0

(( $1 == 0 )) && min=$( tcolor disabled ) || min="set to $( tcolor $1 ) minutes"

title -nt "$info Screen off timeout $min"
