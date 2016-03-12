{ gsub(/[ \t\r]*/,"") 
  gsub(/#.*$/,    "") }

/^$/ { next }

$0 ~ /,$/ { 
  b4 = b4 $0; next }

{ print b4 $0
  b4 = ""  }

END { if (b4) print b4 }
 
