#!/bin/bash

version=20170901

rm $0

wget -qN https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh

if [[ -e /etc/motd.logo ]]; then
  echo -e "$info Rune logo motd already installed."
  exit
fi

title -l = "$bar Install Rune logo motd ..."

wgetnc https://github.com/rern/RuneAudio/raw/master/motd/uninstall_motd.sh -P /usr/local/bin
chmod +x /usr/local/bin/uninstall_motd.sh

echo -e "$bar Modify files ..."

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
 " > /etc/motd.logo

mv /etc/motd{,.original}

echo '#!/bin/bash

color=45

echo -e "\e[38;5;${color}m$( < /etc/motd.logo )\e[0m\n"
' > /etc/profile.d/motd.sh

sed -i -e '/^PS1=/ s/^/#/
' -e '/PS1=/ a\
color=242\
PS1=\x27\\[\\e[38;5;\x27$color\x27m\\]\\u@\\h:\\[\\e[0m\\]\\w \\$ \x27
' /etc/bash.bashrc
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

redis-cli hset addons motd $version &> /dev/null

title -l = "$bar Rune logo motd installed successfully."
echo -e "\nUninstall: uninstall_motd.sh"
title -nt "$info Relogin to see new Rune logo motd."
