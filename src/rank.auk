
@include "lib.awk"

"""

Background
----------

This file implements a Scott-Knott procedure which recursively divides
a population if Cohen's rule says they are not similiar
     
+ i.e. their means are different than 30% of the whole population;

The cut-point is computed via Mittas and Angelesis' rule:

+ i.e. the best cut is the one that maximizes the difference between
  the mean of the uncut population and the weighted sum of the 
  means of the two cut halves.

As a sanity check, the non-parametric aI2 procedure is applied
to test that the two cuts are actually different.

Top-Level Drivers
------------------

The `ranks` function reads data from file, divides that data it into various treatments,
sorts those treatments by their mean score, then ranks each one using Scott-Knott. 

For example, here's the file data/skb.txt:

     rx1 0.34 0.49 0.51 0.8
     rx2 0.6  0.9  0.8  0.9
     rx3 0.7  0.9  0.8  0.6
     rx4 0.2  0.3  0.35  0.4

This outputs:

    ---| data/skb.txt |---------------------
    rx4  :mu 0.3125 :rank 1
    rx1  :mu 0.535 :rank 2
    rx3  :mu 0.75 :rank 3
    rx2  :mu 0.8 :rank 3

Code:

"""

function ranks(f,a,    _Nums,_Div,i,k,max) {
   print "\n----|", f,"|---------------------"
   obs(f,0,_Nums,_Div)
   rank(0,_Nums,_Div,a)
   max = length(order)
   for(i=1;i<=max;i++) {
     k = order[i]["="]
     print k, names[k], ":mu", mus[k], ":rank",labels[k] }
}

"""

Finally, `_rank` is a test engine that runs all the above.

"""

function _rank(    a) {
  args("-d,data/skb.txt,-cohen,0.3,--mittas,1,-a12,0.6",a)
  ranks("data/ska.txt",a)
  ranks("data/skb.txt",a)
  ranks("data/skp.txt",a)
  ranks("data/skc.txt",a)
  ranks("data/skd.txt",a)
  ranks("data/ske.txt",a)
}

"""

Working Memory
---------------

The following code carries around two items of working memory: `_Num` and `_Div`

### _Num

Given data divide into `k` buckets then for each bucket

+ mean = `mu[k]` 
+ `sum[k]` is the sum of the numbers in each bucket;
+ `m2]k]` is the Knuth statistic kept for incremental calculation of the standard deviation;
+ variance = `var[k]`
+ items in each bucket = `n[k]`
+ the items themselves are stored in `x[k][ 1 ].. x[k][ n[k] ]`
+ optionally, buckets can be tagged with `label[k]`
+ and the fact that bucket `k` exists is stored is known as `name[k]`

### _Div

This is the working memory of the recurive divions process:

+ The `total` population size (all measures in all treatments);
+ The magic threshold for the `cohen` rule; defaults to 0.3
+ The `mittas` variable enables (or disables)  Mittas' rule.
+ The magic threshold for the `a12` test; defaults to 0.6;
+ After sorting each bin, their positions are stored in `order`;
+ Here's a low-level detail: the depth of the recursion is stored in `level`.


Code
----

### Reading in Data


`Obs` is a function to read some names and numbers from a file and store
them as list of treatments. This reader ignores all whitespace. Anything
that does not start with a number of a decimal point is assumed to be the
name of some new treatment.

Note one detail: if `obs` reads details on _"n"_ treatments, it builds _"n+1"_ buckets. The `all` bucket
stores details on what is true across all the treatment information.

"""

function obs(f,all,_Nums,_Div,   now,i,v)  {
    now = all
    while((getline  < f ) > 0) {
      for(i=1;i<=NF;i++) 
        if ($i ~ /^([^0-9]|\.)/) 
          now = $i
        else {
          v = $i+0
          inc(v, now,_Nums)
          inc(v, all, _Nums)
        }}
    close(f)
    for(i in names) 
      if (i != all) {
        order[i]["="] = i
        order[i]["x"] = mus[i]
      }
    asort(order,order,"xsort")
}

"""

`Obs` uses the `inc` function to add information about the number `v` into a set
of `_Num` variables. That information includes the number of values seen, their mean,
and their standard deviation.

"""

function inc(v,k,_Num,   all,delta) {
    name[k]
    label[k]  = 0
    all       = ++n[k]
    x[k][all] = v
    sum[k]   += v
    delta     = v - mu[k]
    mu[k]    += delta/all
    m2[k]    += delta*(v - mu[k])
    var[k]    = m2[k]/ (all - 1 + PINCH)
}

"""

### Ranking the data

#### rank

`rank`  checks for certain flags then calls the main worker `rdiv`:

- If called with "-cohen 0", this disables Cohen's rule.
- If called with "--mittas", this disables  Mittas' rule.
- If called with "-a12 0", this disables the A12 test.

Code:

"""

function rank(all,_Nums,_Div,a,    i) {
     cohen  = a["-cohen"]*sqrt(vars[all])
     mittas = a["--mittas"]
     a12    = a["-a12"]
     level  = 0
     total  = ns[all]
     rdiv(1,length(order),1,_Nums,_Div)
}

"""

#### rdiv

Here is the standard recursive divide procedure. If we can find some
place to cut the data, then recurse up to `cut-1` then recurse above that.
If we can't find a cut, increment a cluster number and set everything here to
one cluster value.

"""

function rdiv(lo,hi,c,_Nums,_Div,    i,cut) {
  cut = div(lo,hi,_Nums,_Div)
  if (cut) {
    level++
    c = rdiv(lo,cut-1,c, _Nums,_Div) + 1
    c = rdiv(cut,hi  ,c, _Nums,_Div)
  } else 
    for(i=lo; i<=hi; i++) 
      labels[order[i]["="]] = c
  return c
}

"""

#### div

Here is the `div` function that applies Cohen's rule, Mittas' rule,
and the a12 procedure. Note that this code has three `continue` statements.
That is, we only update the `cut` if all three tests (Cohen, Mittas, a12) are
satisfied.

"""

 function div(lo,hi,_Nums,_Div,   
                _Num0, _Num1,max,b,i,left,
                muLeft,right,muRight,e,cut,
                muAll ) {
   muAll = divInits(lo,hi,_Nums,_Div,_Num0,_Num1)
   max   = -1
   for(i=lo+1;i<=hi;i++) {
     b       = order[i]["="]
     n0[i]   = n0[i-1]   + ns[b]
     sum0[i] = sum0[i-1] + sums[b] 
     left    = n0[i] 
     muLeft  = sum0[i]  / left
     right   = n1[i]
     muRight = sum1[i]  / right
     e = errDiff(muAll,left,muLeft,right,muRight)
     if (cohen)
       if (abs(muLeft - muRight) <= cohen)
         continue
     if (mittas) 
       if (e < max)
         continue
     if (a12)
       if(bigger(lo,i,hi,_Nums,_Div) < a12)
         continue
     max = e
     cut = i
   }    
   return cut 
}

function errDiff(mu,n0,mu0,n1,mu1) {
  return n0*(mu - mu0)^2 + n1*(mu - mu1)^2
}

"""

The `div` function is a little more complex than it needs to be, since it includes
a certain optimization.

+ When looking for splits to the data, it needs to find the mean
  the left and to the right ofthe current split.
+ This requires a lot of running up and down the treatments.
+ So, as an optimization, 
    + _before_ the main `for` loop, we pre-compute and cache
      the means and total counts seen on the right-hand-side of the cut (from `i` up to `hi`).
    + Then, _during_ the main `for` loop, we incrementally
      update counts for the means and totals seen to the left of the cut (from `lo` to `i`)
    + This means that the whole thing requires just two passes
      over `lo` to `hi` (and not one pass for each item between `lo` and `hi`).

#### divInts

The helper function `divInits` is called first line of `div`. It initializes
our knowledge of the left hand side counts and all the right-hand-side counts.

"""

function divInits(lo,hi,_Nums,_Div,_Num0,_Num1,   b,i) {
  b= order[lo]["="]; n0[lo]= ns[b]; sum0[lo]= sums[b];
  b= order[hi]["="]; n1[hi]= ns[b]; sum1[hi]= sums[b]
  for(i=hi-1; i>=lo;  i--) {
     b       = order[i]["="]
     n1[i]   = n1[i+1]   +  ns[b]
     sum1[i] = sum1[i+1] +  sums[b]
   }
  return sum1[lo]/n1[lo]
}

"""

### Calculating the a12 statistic

The rest of the code is not complex- it just implements the a12 test.

"""

function bigger(lo,mid,hi,_Nums,_Div,   below,above) {
  values(below, lo,   mid-1, _Nums,_Div)
  values(above ,mid,  hi, _Nums,_Div)
  return a12statistic(below,above)
}
function a12statistic(below,above,   
                      i,j,comparisons,more,same) {
  for(j in above) 
    for(i in below) {
      comparisons++
      more += above[j] >  below[i]
      same += above[j] == below[i]
    }
  return (more + 0.5*same)/comparisons
}

function values(out,i,j,_Nums,_Div,   k,b,l,m) {
  for(k=i;k<=j;k++) {
    b = order[k]["="]
    for (l in xs[b]) 
      out[++m] = xs[b][l]
  }
  return m
}

