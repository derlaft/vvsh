#!/bin/bash

sqlite_query() {
  local database_name

  database_name="$1"; shift

  sqlite3 "$database_name" "$@"
}

sqlite_query_ok() {
  local result, database_name

  database_name="$1"; shift
  result=$(query "$1" "$@")

  if [ -n "$result" ]; then
    return true
  else
    return false
  fi
}

sqlite_query_fail() {
  local result, database_name

  database_name="$1"; shift
  result=$(query "$1" "$@")

  if [ -z "$result" ]; then
    return true
  else
    return false
  fi
}

sequre() {
  echo -e "$@" | sed -e "s/'/\\\\'/g"
}
