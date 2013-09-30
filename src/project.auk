BEGIN { FS=OFS=","}  
@include "lib.awk" 
@include "reader.awk" 
@include "dist.awk"   

""" 

Spectral Projection
-------------------

Spectral learners use eigenvectors to reason about data.  Eigenvectors
are a construct derived from a table of data that combine related
features and ignore irrelevant features Eigenvectors are linear
combinations of the raw features where the value _cos(&theta;)_
between a raw feature and an eigenvector shows the impact of the
former on the later (if _cos(&theta;)=0_ then _&theta;=90_ degrees and
that feature does not contribute to the overall direction of the data.

An example of spectral learning is the spectral clusterer
implemented in [tiles.auk](?tiles.auk). But before we
look at that, we need the `project` support tool shown in this
file.

As a pre-processor to spectral learning, the `project` code projects
N-dimensional data onto a 2-d space defined by an approximation to the
major eigenvector of some data.  This approxiamtion is generated using
the FASTMAP heuristic that finds the dimension of the greatest
variability.

FASTMAP is similar to Principal Component Analysis (PCA).  and defines
the direction of the greatest variability to be a line drawn between
two most distant points in the examples.  This line approximates the
first component of PCA, but it is generated in much faster time
(linear time for FASTMAP, quadratic time for PCA).  The second
dimension is defined by drawing a perpendicular line to the first
dimension.

Studies showed the effectiveness of FASTMAP for software engineering
data:

+ _Tim Menzies, Andrew Butcher, David Cok, Andrian Marcus, Lucas Layman, Forrest Shull, Burak Turhan, Thomas Zimmermann, "Local versus Global Lessons for Defect Prediction and Effort Estimation," IEEE Transactions on Software Engineering, vol. 39, no. 6, pp. 822-834, June, 2013_

The FASTMAP heuristic
works as follows:

+  Pick any example _Z_ at random;
+ Find the example _X_ furthest from _Z_.
+ Find the example _Y_ furthest from _X_.
+ Find the distance _c=dist(X,Y)_.
+ For all examples _E_, find the distance _a,b_ to _X,Y_.

## Details

+ The raw distance measure is the Euclidean measure used
before in [dist.auk](?dist.auk).
+ From the  cosine rule,  we can  now project and example 
  onto a line from _X_ to _Y_  at _x=(a^2 + c^2 - b^2)/(2c))_.
+ From Pythagoras, we can find _y=sqrt(a^2 -x^2)_.

## Code

Top level-driver:

"""

function project(_Table,t,  d,east,west,x,y) {
  d    = anyi(data) 
  east = furthest(d,   _Table[t])
  west = furthest(east,_Table[t])
  project0(east,west,_Table[t],x,y)
  return widen(_Table,t,x,y)
}

"""

The worker:

+  If we ever find something further away than `c`, then start
again (see the recursive calls to `project0`).

Note that this worker populates to arrays `x,y` whose index
are row numbers and whose values are the _(x,y)_ values of
row number _d_.

"""

function project0(east,west,_Table,x,y,
	      a,b,c,d,some) {
  printf("+")
  some = 0.000001 # handles a tedious div/zero error
  c = dist(data[east],data[west],_Table)
  for(d in data) {
    a = dist(data[d],data[east],_Table)
    b = dist(data[d],data[west],_Table)
    if (b > c) 
      return project0(east,d,_Table,x,y)
    if (a > c) 
      return project0(d,west,_Table,x,y)
    printf(".")
    x[d]=  (a^2 + c^2 - b^2) / (2*c + some)
    y[d]=  (a^2 - x[d]^2)^0.5   
  }
}

"""

Once these _(x,y)_ values are calculated for each example, we can
  build a new table with two extra columns for these new values.

"""

function widen(_Table,t,x,y,   w,d,wider,adds,c) {
  copy(name[t],adds)
  push("$_XX",adds)
  push("$_YY",adds)
  push("$_Hell",adds)
  push("_ZZ",adds)
  w = "_" t
  makeTable(adds,w,_Table)
  for(d in data[t]) {
    copy(data[t][d],wider)
    push(x[d],      wider)
    push(y[d],      wider)
    push(fromHell(data[t][d],_Table[t]),wider)
    push(0,         wider)
    addRow(wider,_Table[w])
  }
  return w
}

"""

## Output

Here's the 26 dimensions of [nasa93demo

<img width=500 src="http://unbox.org/open/trunk/573/13/fall/doc/img/nasa9326.png">

"""