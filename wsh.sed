#for all non-code strings
/^[^%]/{
  
  s/"/\\"/g;
  s/^/echo -ne "/g;
  s/$/"/g;
  s/perform/show/g;
}

#delete our code marks
s/^%//g;
#return newlines
s/@@LBR;@@/\\n/g;
