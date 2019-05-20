#!/bin/bash

alias=bbtn

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

title -l '=' "$bar Modify file ..."

file=/srv/http/app/templates/enhancebody.php
echo $file

commentH 'db-home'

commentH 'db-back'

string=$( cat <<'EOF'
			<div id="db-home"><i class="fa fa-library"></i></div>
			<i id="db-back" style="float: left; width: 60px;" class="fa fa-arrow-left"></i>
			<span></span>
EOF
)
appendH 'db-home'

file=/srv/http/assets/js/enhance.js
echo $file

comment 'left plsbackroot'

string=$( cat <<'EOF'
		$( '#pl-currentpath' ).html( '<i class="fa fa-arrow-left plsbackroot"></i>'+ plcounthtml );
EOF
)
append 'left plsbackroot'

file=/srv/http/assets/js/enhancefunction.js
echo $file

comment 'plsback'

string=$( cat <<'EOF'
		$( '#pl-currentpath' ).html( '<i class="fa fa-arrow-left plsback"></i><a class="lipath">'+ name +'</a></ul>'+ counthtml );
EOF
)
append 'plsback'

installfinish $@

restartlocalbrowser
