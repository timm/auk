BEGIN {FS="\n"; RS=""}
{ lhs=rhs=""
  for(i=1;i<=NF;i++)  {
    gsub(/#.*/,"",$i)     # no comments
    gsub(/[ \t]*/ ,"",$i) # no blanks
    if ($i)               # if anything left...
      if (i==1)           # first word is LHS
	#lhs= "\\<"$i"\\([][a-zA-Z0-9_]*\\)\\>"
	lhs= ""$i"\\([][a-zA-Z0-9_]*\\)"
      else                # other words are RHS
	rhs = (rhs ? rhs "," : "") $i "\\1"
  }
  if (++Seen[lhs] == 1)
    print "s/"lhs"/"rhs"/g" make
  else     
    print "W> already defined: "lhs".">"/dev/stderr"
}
