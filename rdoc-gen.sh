#!/bin/bash 
rm -rfv ./doc
rdoc --accessor --all --charset utf8 --diagram --force-update --image-format png --line-numbers --promiscuous --title 'OpenMirror - (c) 2010 P.Santos' --exclude 'install.rb'
