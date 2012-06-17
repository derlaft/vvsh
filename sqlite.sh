#!/bin/bash

s3query() {
  local database_name

  database_name="$1"; shift

  sqlite3 "$database_name" "$@"
}

s3query_ok() {
  local result, database_name

  database_name="$1"; shift
  result=$(query "$1" "$@")

  if [ -n "$result" ]; then
    return true
  else
    return false
  fi
}

s3query_fail() {
  local result, database_name

  database_name="$1"; shift
  result=$(query "$1" "$@")

  if [ -z "$result" ]; then
    return true
  else
    return false
  fi
}

s3strip_quotes() {
  echo -e "$@" | sed -e "s/'/\\\\'/g"
}
