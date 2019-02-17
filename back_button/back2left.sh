#!/bin/bash

sed -i -e '/db-home\|db-back/ d
' -e '/db-webradio-new/ i\
            <div id="db-home"><i class="fa fa-library"></i></div>\
            <i id="db-back" style="float: left" class="fa fa-arrow-left"></i>\
            <span></span>
' /srv/http/app/templates/enhancebody.php
