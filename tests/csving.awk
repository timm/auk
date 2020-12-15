# vim: filetype=awk ts=2 sw=2 sts=2  et :

function csv1ing(f,     i,n) {
  while(csv(a,f)) n+= length(a)
  print n }

function csving(f,     i,n) {
  Csv(i,f)
  while(it(i)) n += length(i.fields)
  print(n) }

BEGIN { 
  print("\n--- Csv")
  csving(data("auto93")) }

function data(f,  d) { 
  d=Gold.dot
  return d d "/data/" f d "csv" }
