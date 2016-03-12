function line(f,   str) {
  f = f ? f : "/dev/stdin"
  if ((getline str < f) > 0) {
    gsub(/[ \t\r]*/,"",str) 
    gsub(/#.*$/,"",str)
    if ( str ~ /,[ \t]*$/ )
      return str line(f)
    else
      return str 
  } else
    return -1
}
 { print line() }
