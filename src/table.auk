@include "reader.awk"

function tableprint(_Table,stats,   com,max,i,c,row,old) {
  print ""
  old=CONVFMT
  CONVFMT = stats
  com = malign()
  print rowprint(name) ", #     notes"   | com 
  if (stats) {
    centroid(_Table,row)
    print "# "rowprint(row)", #  expected" | com
    for(c in name)
      row[c] = c in nump ? sd[c] : most[c]/n[c]
    print "# " rowprint(row) ", # certainty" | com
    }
  max =length(data)
  for(i=1;i<=max;i++)
    print rowprint(data[i]) ", #"  | com
  close(com) 
  CONVFMT=old
}
function centroid(_Table,out,   c) {
  new(out)
  for(c in name)
    out[c] =  c in nump ? mu[c] : mode[c]
}
function expected(what,_Table,    c) {
  for(c in name)
    if (name[c] == what)
      return c in nump ? mu[c] : mode [c]
}
