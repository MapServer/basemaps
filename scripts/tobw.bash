#!/usr/bin/env bash
#
# Converts RGB colors to grayscale in given style file (can be an extract of generate_style.py to convert a style to B&W)
#
# usage tobw.bash file
# outputs the converted file
#
#awk '/[0-9]+ [0-9]+ [0-9]+/ {print $1 $2 $3}' $1

#awk '{ if (/([0-9]+) ([0-9]+) ([0-9]+)/) { print "matched" } else { print $1 } }' $1

#awk 'match($0, /clr/, ary) {print ary[1]}' $1


