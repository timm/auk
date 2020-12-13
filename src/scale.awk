#!/usr/bin/env ./auk.sh
# vim: filetype=awk ts=2 sw=2 sts=2  et :

#<
SCALE: StoChAstic LandscapE analysis
(c) 2020 MIT License, Tim Menzies timm@ieee.org
Optimization via discretization and contrast sets.
#>

BEGIN {   
  Gold.scale.Tab.samples = 64
  Gold.scale.Some.div.min = 0.5
  Gold.scale.Some.div.epsilon = 0.3
}

### shortcuts
function add(i,x,  f) { f= i.is"Add"; return @f(i,x) }


### columns
## generic column
function Col(i,pos,txt) {
  Obj(i)
  i.is="Col"
  i.pos=pos
  i.txt=txt
  i.n  =0
  i.w  =txt ~ /</ ? -1 : 1 }

## columns whose data we will ignore
function Skip(i,pos,txt) { Col(i,pos,txt); i.is = "Skip" }
function _Add(i,x)       { return x }

## columns of symbols which we will summaries
function Sym(i,pos,txt) {
  Col(i, pos,txt)
  i.is = "Sym"
  has(i,"seen")
  has(i,"bins")
  i.mode=i.most="" }

function _Add(i,x,    d,n) {
  if (x!="?") {
    n = ++i.some[x]
   if(n>i.most) { i.most=n; i.mode=x} }
  return x }

## columns of numbers, from which we will keep a sample
function Some(i,pos,txt) {
  Col(i,pos,txt)
  i.is="Some"
  i.ok= 1
  i.want=128 # number of samples
  i.lo =  1E30
  i.hi = -1E30
  has(i,"all") }

function _Add(i,x,    len,pos) {
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

function _Ok(i) { i.ok = i.ok ? i.ok : asort(i.all) }

function _Mid(i,lo,hi) { return _Per(i,.5,lo,hi) }

function _Sd(i,lo,hi) {return( _Per(i,.9,lo,hi) - _Per(i,.1,lo,hi))/2.54}

function _Per(i,p,lo,hi) { 
  _Ok(i)
  lo = lo?lo:1
  hi = hi?hi:length(i.all)
  return i.all[ int(lo + p*(hi-lo)) ] }

function _Norm(i,x,   n) {
  if (x=="?") return x
  x= (x-i.lo) / (i.hi - i.lo +1E-32)
  return x<0 ? 0 : (x>1 ? 1 : x) }

function _Div(i,x,bins) { _Div1(i,x,Gold.scale.Some.div) }

function _Div1(i,x,the,         b,n,lo,hi,b4,len,eps) {
  _Ok(i)
  eps = _Sd(i)*the.epsilon
  len = length(i.all)
  n   = len^the.min
  while(n < 4 && n < len/2) n *= 1.2
  n   = int(n)
  lo  = 1
  b4  = b = 0
  for(hi=n; hi <= len-n; hi++) {
    if (hi - lo > n) 
      if (i.all[hi] != i.all[hi+1]) 
        if (b==0 || ( _Mid(i,lo,hi) - b4) > eps) {
          i.bins[++b] = i.all[hi]
          b4 = _Mid(i,lo,hi)
          lo = hi }}}

### rows of data
function Row(i,a,t,     j) {
  Obj(i)
  i.is = "Row"
  i.dom = 0
  has(i,"cells") 
  for(j in a) i.cells[j] = add(t.cols[j], a[j]) }

function _Dom(i,j,t,   
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
function Tab(i) {
  Obj(i)
  i.is = "Tab"
  has(i,"xs")
  has(i,"ys")
  has(i,"rows")
  has(i,"cols") }

function _What(i,pos,txt,  x,where) {
  x="Sym"
  if (txt ~ /[<>:]/) x="Some"
  if (txt ~ /\?/)    x="Skip"
  if (x != "Skip") {
    where =  txt ~ /[<>!]/ ? "ys" : "xs"
    i[where][pos] }
  return x }
 
function _Add(i,a,    j) {
  if (length(i.cols)>1) 
    hAS(i.rows, int(1E9 * rand()) ,"Row",a,i)
  else 
    for(j in a)
      hAS(i.cols, j, _What(i,j,a[j]), j, a[j]) }

function _Dom(i,   n,j,k) {
  for(j in i.rows) {
    n= Gold.scale.Tab.samples
    for(k in i.rows) {
       if(--n<0) break
      if(i.rows[j].id > i.rows[k].id) 
        i.rows[j].dom += RowDom(i.rows[j], i.rows[k],i)}}
 }
   

function _Read(i,f,  a) {  while(csv(a,f)) add(i,a) }

### main
function main(f,    c,i,bins) {
  Tab(i)
  TabRead(i,data(f ? f : "weather") )
  TabDom(i)
  for(c in i.cols)  {
    if (i.cols[c].is=="Some") {
      delete bins
      SomeDiv(i.cols[c])
      oo(i.cols[c].bins,c) }}}

function data(f) { return Gold.dots "/data/" f Gold.dot "csv" }

BEGIN { srand(Gold.seed ? Gold.seed : 1) 
        main("auto93")
        rogues()  }

