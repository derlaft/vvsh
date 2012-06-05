#!/bin/bash

[ -z "$DIR" ] && DIR=$(dirname $0)
[ -z "$MAXLEN" ] && MAXLEN=5120 #5M
source $DIR/obj.sh
wsh_init
wsh_compile $@
wsh_clear
