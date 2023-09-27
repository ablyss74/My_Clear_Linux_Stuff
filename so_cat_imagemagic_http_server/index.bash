#!/usr/bin/env bash
###############################################################
#          Example httpd server page with ImageMagick 
#
#       To run, open terminal and type:
#	bash ./index.bash
#	Open a modern web browser to http://localhost:1234
#	Try out different fonts
#
###############################################################

#  Optional flags 
#flags="-d -d"
#flags="-v -v"
#flags="-T 1"

socat ${flags} TCP-LISTEN:1234,crlf,reuseaddr,fork SYSTEM:"
echo HTTP/1.0 200
echo Content-Type\: text/html; echo
#
. ./example.bash
"


