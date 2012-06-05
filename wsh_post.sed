1h;1!H;${;g;  
  #delete echos we don't need
  s/echo -n*e "[ \n]*";*//g;
  #and empty lines
  s/\n  *\n/\n/g;
p;}
