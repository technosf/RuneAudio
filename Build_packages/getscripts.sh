#!/bin/bash

# get build scripts

# getScripts PACKAGE 1 - RPi 1, Zero
# getScripts PACKAGE   - All except RPi 1, Zero

getScripts() {
    [[ -z $2 ]] && arch=armv7h || arch=armv6h
    url=https://archlinuxarm.org/packages/$arch/$1
    echo Get build script list ...
    files=$( curl -s $url/files | sed -n '/<tbody/,/<\/tbody>/ p' | grep href= | sed 's/.*">\(.*\)<\/a>.*/\1/' )
    echo
    for file in $files; do
        echo Get $file ...
        curl -s $url/files/$file \
            | sed -n '/<pre>/,/<\/pre>/ p' \
            | sed 's/.*<pre><code>\|<\/code><\/pre>//g' > $file
    done
}
