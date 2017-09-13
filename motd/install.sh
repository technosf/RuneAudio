#!/bin/bash

# required variables
alias=motd
title='Login Logo for SSH Terminal'

rm $0

wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

function checkinstall() {
	if [[ -e /usr/local/bin/uninstall_$alias.sh ]]; then
	  title -l '=' "$info $title already installed."
	  title -nt "Please try update instead."
	  redis-cli hset addons $alias 1 &> /dev/null
	  exit
	fi
}
checkinstall

[[ $1 != u ]] && title -l '=' "$bar Install $title ..."

wgetnc https://github.com/rern/RuneAudio/raw/master/motd/uninstall_motd.sh -P /usr/local/bin
chmod +x /usr/local/bin/uninstall_motd.sh

echo -e "$bar Add new files ..."

file=/etc/motd.logo
echo $file
echo "
                          .,;uh         
                   .,;cdk0XNWMM,        
             .,cdONMMMMMMMMMMMM:        
         .:kXWMMMWKkdolcclkMMMM:        
        ;WMMMXx?'''        KMMM:        
        :MMN'              xMMM.        
        .WMMc             :0MMM         
         dMMW;      ,     :WMMM         
         .NMMWxdxkK0;     'NMMM.        
          cMMMMWKx;:      'kMMM.        
           :lNNl''   ,     oMMM:        
                  .oK;     xMMM,        
              .unWMNc     .NMMd         
               ':do:'     kMMk'         
                        .kMMx'          
                      .oNMX;'           
               k,   .dWMWo'             
               kMNo0WMXo'               
                dNNOd;'                 
                 ''                     
 " > $file

file=/etc/profile.d/motd.sh
echo $file
echo '#!/bin/bash

color=45

echo -e "\e[38;5;${color}m$( < /etc/motd.logo )\e[0m\n"
' > $file

echo -e "$bar Modify files ..."

mv -v /etc/motd{,.original}

file=/etc/bash.bashrc
echo $file
sed -i -e '/^PS1=/ s/^/#/
' -e '/PS1=/ a\
color=242\
PS1=\x27\\[\\e[38;5;\x27$color\x27m\\]\\u@\\h:\\[\\e[0m\\]\\w \\$ \x27
' $file
# PS1='\[\e[38;5;'$color'm\]\u@\h:\[\e[0m\]\w \$ '
# \x27       - escaped <'>
# \\         - escaped <\>
# \[ \]      - omit charater count when press <home>, <end> key
# \e[38;5;Nm - color
# \e[0m      - reset color
# \u         - username
# \h         - hostname
# \w         - current directory
# \$         - promt symbol: <$> users; <#> root

function saveversion() {
	version=$( sed -n "/alias.*$alias/{n;p}" /srv/http/addonslist.php | cut -d "'" -f 4 )
	redis-cli hset addons $alias $version &> /dev/null
}
saveversion

function installfinish() {
	if [[ $1 != u ]]; then
		title -l '=' "$bar $title installed successfully."
		[[ -t 1 ]] && echo -e "\nUninstall: uninstall_$alias.sh"
		(( $# != 0 )) && title -nt $1
	else
		title -l '=' "$bar $title updated successfully."
	fi
}
installfinish "$info Relogin to see new $title."
