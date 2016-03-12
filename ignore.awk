@include "config"

BEGIN { FS="," }

NR==1 { 
  for(I=1;I<=NF;I++) 
    Ignore[I] = $I !~ IgnoreC }

{ print dump(Use) }

function dump(use,    i,out,sep) {
  for(i=1;i<=NF;i++) 
    if (Ignore[i]) {
      out = out sep $i
      sep = "," }
  return out }
