#!/bin/bash
echo $#
if (( $# > 0 )); then
	sudo systemctl start mpd
	sudo redis-cli set activePlayer MPD
	curl -s -X POST 'http://localhost/pub?id=airplay' -d 0
else
	sudo systemctl stop mpd
	sudo redis-cli set activePlayer Airplay
	curl -s -X POST 'http://localhost/pub?id=airplay' -d 1
fi
