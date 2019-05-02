#!/bin/bash

# ID3 tag editor

version=$( python -V | cut -d' ' -f2 )
[[ ${version:0:1} == 3 ]] && pip=python-pip || pip=python2-pip
pacman -Sy $pip
pip install mutagen
