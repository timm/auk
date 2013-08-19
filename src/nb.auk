@include "reader.awk"

function bayes(z,_Table,     seen,d,this) {
  for (d in data[z]) {
    this = theKlass(d,_Table[z])
    if(! (this in seen)) {
      seen[this]
      makeTable(name[z],this,_Table)
    }
    addRow(data[z][d],_Table[this])
}}
function theKlass(d,_Table,    k) {
  for(k in klass)
    return data[d][k]
}
function _nb(     _Table,   seen,x,f){
  readcsv("data/weather1.csv", 0, _Table)
  bayes(0,_Table)
  f="%4.2f"
  tableprint(_Table[0],f)
  tableprint(_Table["yes"],f)
  tableprint(_Table["no"], f)
}
