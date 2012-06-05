#for pair macros

#for name, value in param; do
#to
#[ -n ${!name[@]} ] && for name in ${!param[@]}; do value="${param[$name]}";

s/for \([a-zA-Z0-9_][a-zA-Z0-9_]*\) *, *\([a-zA-Z0-9_][a-zA-Z0-9_]*\) in \([a-zA-Z0-9_][a-zA-Z0-9_]*\); *do *;*/[ "${#\3[@]}" -ne '0' ] \&\& for \1 in "${!\3[@]}"; do \2="${\3[$\1]}"; /g;

#'then' fix
s/then *;/then /g;

#'do' fix
#s/;[\n ]*do[\n ]*;/; do/g;
