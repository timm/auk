#!/usr/bin/env ./auk.sh
# vim: filetype=awk ts=2 sw=2 sts=2  et :

#<
SCALE: StoChAstic LandscapE analysis
(c) 2020 MIT License, Tim Menzies timm@ieee.org
Optimization via discretization and contrast sets.

def. scale (v):
-   To climb up or reach by means of a ladder;
-   To attack with or take by means of scaling ladders;
-   To reach the highest point of (see also SURMOUNT)

                              Hooray!   .
                                 -. _ O /
                                     _ '
                                    / \
                                    ())
         _ _      _..--.. .-' _-.     .-d-b-.
     --'   _ _.-'        _ _.. _.  _  .'        _.   _.
        .-'                  a:f          ,-'
#>

BEGIN {   
  Gold.scale.Tab.samples = 64
  Gold.scale.Some.div.min = 0.5
  Gold.scale.Some.div.epsilon = 0.3
}

### shortcuts
func add(i,x,  f) { f= i.is"Add"; return @f(i,x) }

### columns
## generic column
func Col(i,pos,txt) {
  Obj(i)
  i.is="Col"
  i.pos=pos
  i.txt=txt
  i.n  =0
  i.w  =txt ~ /</ ? -1 : 1 }

## columns whose data we will ignore
func Skip(i,pos,txt) { Col(i,pos,txt); i.is = "Skip" }
func _Add(i,x)       { return x }

## columns of symbols which we will summaries
func Sym(i,pos,txt) {
  Col(i, pos,txt)
  i.is = "Sym"
  has(i,"seen")
  has(i,"bins")
  i.mode=i.most="" }

func _Add(i,x,    d,n) {
  if (x!="?") {
    n = ++i.some[x]
   if(n>i.most) { i.most=n; i.mode=x} }
  return x }

##columns of numbers, from which we will keep a sample
func Some(i,pos,txt) {
  Col(i,pos,txt)
  i.is="Some"
  i.ok= 1
  i.want=128 # number of samples
  i.lo =  1E30
  i.hi = -1E30
  has(i,"all") }

func _Add(i,x,    len,pos) {
  if (x != "?") {
    i.n++
    len=length(i.all)
    if        (i.n < i.want)        pos=len + 1
    else  {if (rand() < i.want/i.n) pos=int(len*rand())}
    if (pos) {
      if (x < i.lo) i.lo = x
      if (x > i.hi) i.hi = x
      i.ok=0
      i.all[pos]=x }}
  return x }

func _Ok(i) { i.ok = i.ok ? i.ok : asort(i.all) }

func _Mid(i,lo,hi) { return  _Per(i,.5,lo,hi) }

func _Sd(i,lo,hi) {
  return (  _Per(i,.9,lo,hi) -  _Per(i,.1,lo,hi))/2.54 }

func _Per(i,p,lo,hi) { 
   _Ok(i)
  lo = lo?lo:1
  hi = hi?hi:length(i.all)
  return i.all[ int(lo + p*(hi-lo)) ] }

func _Norm(i,x,   n) {
  if (x=="?") return x
  x= (x-i.lo) / (i.hi - i.lo +1E-32)
  return x<0 ? 0 : (x>1 ? 1 : x) }

func _Div(i,x,bins,     eps,min,b,n,lo,hi,b4,len) {
   _Ok(i)
  eps = Gold.scale.Some.div.epsilon
  min = Gold.scale.Some.div.min
  eps =  _Sd(i)*eps
  len = length(i.all)
  n   = len^min
  while(n < 4 && n < len/2) n *= 1.2
  n   = int(n)
  lo  = 1
  b   = b4 = 0
  for(hi=n; hi <= len-n; hi++) {
    if (hi - lo > n) 
      if (i.all[hi] != i.all[hi+1]) 
        if (b4==0 || (   _Mid(i,lo,hi) - b4) >= eps) {
          i.bins[++b]   = i.all[hi]
          b4  =  _Mid(i,lo,hi)
          lo  = hi
          hi += n }}}

### rows of data
func Row(i,a,t,     j) {
  Obj(i)
  i.is = "Row"
  i.dom = 0
  has(i,"cells") 
  for(j in a) i.cells[j] = add(t.cols[j], a[j]) }

func _Dom(i,j,t,   
                 n,e,c,w,x,y,sum1,sum2) {
  n = length(t.ys)
  for(c in t.ys) {
    w     = t.cols[c].w
    x     = SomeNorm(t.cols[c], i.cells[c])
    y     = SomeNorm(t.cols[c], j.cells[c])
    sum1 -= 2.71828 ^ ( w * (x - y)/n )
    sum2 -= 2.71828 ^ ( w * (y - x)/n )
  }
 return sum1/n < sum2/n }

### tables store rows, summarized in columns
func Tab(i) {
  Obj(i)
  i.is = "Tab"
  has(i,"xs")
  has(i,"ys")
  has(i,"rows")
  has(i,"cols") }

func _What(i,pos,txt,  x,where) {
  x="Sym"
  if (txt ~ /[<>:]/) x="Some"
  if (txt ~ /\?/)    x="Skip"
  if (x != "Skip") {
    where =  txt ~ /[<>!]/ ? "ys" : "xs"
    i[where][pos] }
  return x }
 
func _Add(i,a,    j) {
  if (length(i.cols)>1) 
    hAS(i.rows, int(1E9 * rand()) ,"Row",a,i)
  else 
    for(j in a)
      hAS(i.cols, j,  _What(i,j,a[j]), j, a[j]) }

func _Dom(i,order,   n,j,k) {
  for(j in i.rows) {
    n= Gold.scale.Tab.samples
    for(k in i.rows) {
       if(--n<0) break
      if(i.rows[j].id > i.rows[k].id) 
        i.rows[j].dom += RowDom(i.rows[j], i.rows[k],i)}}
  return keysorT(i.rows, order,"dom") 
 }

func _Read(i,f,  a) {  while(csv(a,f)) add(i,a) }  
