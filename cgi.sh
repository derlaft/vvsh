#!/bin/bash

[ -z "$CONFIG" ] && source "$(pwd -P)/config.sh"

source $DIR/obj.sh

wsh_init
wsh_compile $@
wsh_clear
