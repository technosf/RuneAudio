#!/bin/bash

alias=bbtn

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

title -l '=' "$bar Modify file ..."

file=/srv/http/app/templates/enhancebody.php

commentH 'db-home'

commentH 'db-back'

string=$( cat <<'EOF'
			<div id="db-home"><i class="fa fa-library"></i></div>
			<i id="db-back" style="float: left; width: 60px;" class="fa fa-arrow-left"></i>
			<span></span>
EOF
)
appendH 'db-home'

file=/srv/http/assets/js/enhancefunction.js

commentH 'plsback'

string=$( cat <<'EOF'
		$( '#pl-currentpath' ).html( '<i class="fa fa-arrow-left plsback"></i><a class="lipath">'+ name +'</a></ul>'+ counthtml );
EOF
)
appendH 'plsback'

file=/srv/http/assets/js/enhance.js

commentH 'left plsbackroot'

string=$( cat <<'EOF'
		$( '#pl-currentpath' ).html( '<i class="fa fa-arrow-left plsbackroot"></i>'+ plcounthtml );
EOF
)
appendH 'left plsbackroot'

installfinish $@

restartlocalbrowser
