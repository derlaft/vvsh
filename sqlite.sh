#!/bin/bash

s3query() {
  local database_name

  database_name="$1"; shift

  sqlite3 "$database_name" "$@"
}

s3query_ok() {
  local result, database_name

  database_name="$1"; shift
  result="$(query "$database_name" "$@")"

  if [ -n "$result" ]; then
    return 0
  else
    return 42
  fi
}

s3query_fail() {
  local result, database_name

  database_name="$1"; shift
  result="$(query "$database_name" "$@")"

  if [ -z "$result" ]; then
    return 0
  else
    return 42
  fi
}

s3strip_quotes() {
  echo -e "$@" | sed -e "s/'/\\\\'/g"
}
