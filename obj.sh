#!/bin/bash

source $DIR/utils.sh
declare -A http_params
declare -A http_cookies
declare -A http_files

wsh_init() {
  
  #define vars
  local name
  local line
  local value
  local pair
  local post
  
  if [ "$REQUEST_METHOD" == 'POST' ] && echo "$CONTENT_TYPE" | grep -q 'multipart/form-data'; then
    wsh_readform
    QUERY_STRING=$(echo -e "$QUERY_STRING")
  elif [ "$REQUEST_METHOD" == 'POST' ]; then
    QUERY_STRING=$(echo -e "$QUERY_STRING&$(cat)")
  fi
  
  #get params
  QUERY_STRING=$(echo "$QUERY_STRING" | sed -e 's/^&//;s/&$//')
  
  #separate them
  
  line=$(echo $QUERY_STRING | tr '&' ' ')
  for pair in $line; do
    name=$(echo "$pair" | awk -F'=' '{print $1}')
    value=$(echo "$pair" | awk -F'=' '{print $2}' | sed -e 's/%\(\)/\\\x/g'| tr '+' ' ')
    
    http_params["$name"]="$value"
  done
  
  #get cookies

  HTTP_COOKIE=$(echo -e "$HTTP_COOKIE" | sed -e 's/ /%20/g' | sed -e 's/;%20/ /g')

  for pair in $HTTP_COOKIE; do
    name=$(echo "$pair" | awk -F'=' '{print $1}')
    value=$(echo "$pair" | awk -F'=' '{print $2}' | sed -e 's/%20/ /g')
    
    http_cookies["$name"]="$value"
  done 
  
}

wsh_readform() {
  
  local pair
  local type
  local name
  local temp
  local file

  local info
  local infotemp=$(mktemp)

  #we use dd to tricky cut everything under limit
  dd of="$infotemp" bs='1024' count="$MAXLEN" status=noxfer 2>/dev/null

  if read -n1; then
    rm "$infotemp"
    header 'text/plain'
    echo "request is bigger than ${MAXLEN}Kb"
    exit 1
  fi
  
  info=$(cat "$infotemp" | python $DIR/mpart.py)
  rm "$infotemp"
  
  for pair in $info; do

    
    type=$(echo "$pair" |cut -d';' -f1)
    name=$(echo "$pair" |cut -d';' -f2)
    temp=$(echo "$pair" |cut -d';' -f3)
    filename=$(echo "$pair" |cut -d';' -f4)

    filename=$(echo "$filename" | sed -e 's/[\/`$]//g;s/^\///')
    
    if [ -n "$type$name$temp" ] && [ -z "$filename" ] && [ "$type" == 'param' ]; then
      
      file=$(cat "$temp")

      if [ -n "$file" ]; then
        http_params["$name"]="$file"
      else
        http_params["$name"]='defined'
      fi
        
      rm "$temp"
    elif [ -n "$type$name$temp" ] && [ -n "$filename" ] && [ "$type" == 'file' ]; then
      http_params["$name"]="$filename"
      http_files["$name"]="$temp"
    elif [ -n "$temp" ]; then
      debug 'smth weird' "$type $name $temp $filename"
      debug 'info is' "$info"
      rm "$temp"
    fi
  done
}

wsh_clear() {
  
  #rm uploaded temp files
  for name in "${!http_files[@]}"; do
    rm "${http_files[$name]}"
  done
}

wsh_compile() {

  #set up needed vars
  local wsh
  local temp
  
  #read wsh into var
  wsh=$(cat $1)
  
  #make temp file
  temp=$(mktemp)
  chmod +x $temp
  
  #wrap all text into echos
  
  if echo -e "$wsh" | sed -n '1p' | grep -q '^#!'; then
    wsh=$(echo -e "$wsh" | sed -e '1d')
  fi
  
  #sed time!
  wsh=$(echo -e "$wsh" | sed -n -f $DIR/wsh_pre.sed)
  wsh=$(echo -e "$wsh" | sed -f $DIR/wsh.sed)
  wsh=$(echo -e "$wsh" | sed -n -f $DIR/wsh_post.sed)
  wsh=$(echo -e "$wsh" | sed -f $DIR/macros.sed)
  
  
  #now we can run it
  echo -e "$wsh" > $temp
  source $temp
  
  #and delete
  #in the future - move to the cache
  echo "=>$1<=" 1>&2
  cat $temp 1>&2
  echo '===' 1>&2
  rm $temp
}
