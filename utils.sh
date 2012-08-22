#!/bin/bash

declare -A send_cookies
DEBUG=true

die() {
  wsh_clear
  exit $@
}

print() {
  echo -ne "$@"
}

require() {
  wsh_compile $@
}

app() {
  APP="$@"
}

import() {
  source "$LIBS/$APP/$1.sh"
}

header() {
  local type=$1; shift
  if [ -z "$type" ]; then
    type='text/html'
  fi
  echo "Content-Type: $type"
  send_cookie
  echo
}

redirect() {
  local url=$1; shift
  if [ -z "$url" ]; then
    type='/'
  fi
  echo "Location: $url"
  send_cookie
  echo
}

send_cookie() {
  local name
  local value
  if [ -n "${#send_cookies[@]}" ]; then
    for name in "${!send_cookies[@]}"; do
      value="${send_cookies[$name]}"
      echo "Set-Cookie: $name=$value"
    done
  fi
}

add_cookie() {
  send_cookies["$1"]="$2"
}

perform() {
  echo -e "$@" | markdown -f -html 
}

debug() {
  local mark=$1; shift
  $DEBUG && echo -e "$@" | sed -e "s/^/[DEBUG::$mark]\t/" 1>&2
}
