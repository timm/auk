# vim: filetype=awk  ts=2 sw=2 et :
@include "auk"

function Col(i,at,txt) { Object(i); i.at=at; i.txt=txt}


BEGIN { Col(i,23,"adsa"); oo(i) }

  
