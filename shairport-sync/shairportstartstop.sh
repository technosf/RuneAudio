#!/bin/bash

if (( $# > 0 )); then
	systemctl start mpd
	redis-cli set activePlayer MPD
	curl -s -X POST 'http://localhost/pub?id=airplay' -d 0
else
	systemctl stop mpd
	redis-cli set activePlayer Airplay
	curl -s -X POST 'http://localhost/pub?id=airplay' -d 1
fi
