/^[ \t]*#_[ \t]+/ { 
  lhs=rhs=""
  for(i=2;i<=NF;i++)  {
    if ($i)   {             # if anything left...
      if (i==2)           # first word is LHS
        lhs= "_"$i"\\([][a-zA-Z0-9_\"]*\\)"
      else                # other words are RHS
        rhs = (rhs ? rhs "," : "") $i "\\1"
  }}
  if (++Seen[lhs] == 1)
    print "s/"lhs"/"rhs"/g" make
  else
    print "W> already defined: "lhs".">"/dev/stderr"
}
