#multiline replace
1h;1!H;${;g;

  #delete empty lines
  s/\n[\n ]*\n/\n/g;
  #and replace line breaks
  s/\n/@@LBR;@@/g;

  #then separate the strings
  s/<%/\n%/g;
  s/%>/\n/g;

p;}
