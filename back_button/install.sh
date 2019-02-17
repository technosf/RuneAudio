#!/bin/bash

alias=paus

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

title -l '=' "$bar Modify file ..."

file=/srvhttp/app/templates/enhancebody.php

commentH 'db-home'

commentH 'db-back'

string=$( cat <<'EOF'
			<div id="db-home"><i class="fa fa-library"></i></div>
			<i id="db-back" style="float: left" class="fa fa-arrow-left"></i>
			<span></span>
EOF
)
appendH 'db-home'

installfinish $@

restartlocalbrowser
