#!/bin/bash

[ -z "$CONFIG" ] && source "$(dirname $(readlink -f $0))/config.sh"

source $DIR/obj.sh

wsh_init
wsh_compile $@
wsh_clear
