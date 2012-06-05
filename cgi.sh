#!/bin/bash

[ -z "$DIR" ] && DIR=$(dirname $0)
[ -z "$MAXLEN" ] && MAXLEN=5120 #5M
[ -z "$LIBS" ] && LIBS=/usr/share/vvsh
source $DIR/obj.sh
wsh_init
wsh_compile $@
wsh_clear
