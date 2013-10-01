@include "project.awk"
@include "table.awk"

"""

Spectral Clustering
-------------------

Spectral learners use eigenvectors to reason about data.  Eigenvectors
are a construct derived from a table of data that combine related
features and ignore irrelevant features Eigenvectors are linear
combinations of the raw features where the value _cos(&theta;)_
between a raw feature and an eigenvector shows the impact of the
former on the later (if _cos(&theta;)=0_ then _&theta;=90_ degrees and
that feature does not contribute to the overall direction of the data.

An example of spectral learning is the spectral clusterer shown in this
file. `Tiles` finds the first two dimensions of all rows
then recursively partitions those two dimensions on their median
point.

## Code

### Tiles
		     
This function first calls [project.auk](?project.auk) which populates
two arras _(x,y)_ (you can't see it here since those arrays are part
of the `_Tables_` structure.

Then, it determines a minimum number of examples, less than which the
recursion should stop (see `big`).

The recursion then starts `tiles`. 

"""

function tiles(_Tables,t,    _Tile,m,cl,xy) {
  xy = project(_Tables,t)
  tiny = 4
  pre  = ""
  m    = length(datas[xy])
  big  = 2*sqrt(m)
  cl    = 1
  watch= 1
  centers="centroids"
  makeTable(names[xy],centers,_Tables)
  tiles0(_Tables[xy],_Tile)
  tiles4(1,m,1,m,_Tables[xy],_Tile,_Tables,cl)
  return centers
}
"""		      

This code four indexes that mark the min and max range of the _(x,y)_
ranges (see the last line of `tiles` that calls `1,m,1,m` for
_xmin,xmax,ymin,ymax_).


"""
function tiles0(_Table0,_Tile,  x,y,z,d,at) {
  x = colnum0["$_XX"]
  y = colnum0["$_YY"]
  z = colnum0["_ZZ"]  
  for(d in data0) {
    at[d]["d"] = d
    at[d]["x"] = data0[d][x]
    at[d]["y"] = data0[d][y]
  }
  asort(at,xs,"xsort")
  asort(at,ys,"ysort")
}
"""

Three tricks:

+ Sort all the `x,y` values _once_ in `tiles0` then
pass them sorted to the recursive call.
+ `Tiles4` calls `tile1` which recursively calls `tiles`.
+ The code carries around an id number called `cl` which
  may be updated `tile1` if ever a new cluster is created
+ We also carry around one additional table that stores
  the centroids of the new created tables. If we make a new
  leaf cluster, we also add the centroid of the new cluster
  to the _clusters_ table.

Code:

"""

function tiles4(x0,x2,y0,y2,_Table0,_Tile,_Tables,cl, 
		x,y) {
  x= x0 + int((x2 - x0)/2)
  y= y0 + int((y2 - y0)/2)
  cl= tile1(x0  ,x  ,y0  ,y,  _Table0,_Tile,_Tables,cl)
  cl= tile1(x0  ,x  ,y+1 ,y2, _Table0,_Tile,_Tables,cl)
  cl= tile1(x+1 ,x2 ,y0  ,y,  _Table0,_Tile,_Tables,cl)
  cl= tile1(x+1 ,x2 ,y+1 ,y2, _Table0,_Tile,_Tables,cl)
  return cl
}
"""

The code in `tile1` runs as follows:

+ First, it reflects over the ranges `x0,x2` and `y0,y2`
to see what examples fall into the range `x0` to `x2`
and `y0` to `y2`. The index of each such row is stored in the
`has` array.
+ Then the if statement that tests for `watch` optionally prints
some debug information.
+ Thirdly, 
    + If there are enough items in `has`, then recurse
      to try splitting that into four using `tiles4`.
    + Else, if there enough examples, create a new lead
      cluster and add all the items in `has` to a new table.
          + The new cluster gets a new id number which 
            means that we have to increment the `++cl`
            cluster index value.

Note that `tile1` and `tiles4` must return the cluster id
after all the cluster values `cl` are updated.

"""

function tile1(x0,x2,y0,y2, _Table0,_Tile,_Tables,cl,    
                x,y,has) {
  #-----------------
  # search : find things inside x0..x2 and y0..y2
  for(x=x0; x<=x2; x++) 
    for(y=y0; y<=y2; y++) 
      if (xs[x]["d"] == ys[y]["d"])
        has[x] = xs[x]["d"]
  #-------------------
  # show : some debug info (optional)
  if (watch)
    print sprintf("%3s:  ",cl) pre x0,x2,y0,y2, "#" length(has)
  #-------------------
  # recurse : when there is enough data 
  if (length(has) >= big) {
    pre = pre "|.."
    return tiles4(x0,x2,y0,y2,_Table0,_Tile,_Tables,cl)
  } 
  # ------------------
  # otherwise, new cluster: make a new leaf, only when there is enough data
  if (length(has) > tiny)  
    makeNewTable(has, 
                 ++cl, # <=== we are now making a new cluster
                 _Table0,_Tile,_Tables)
  #------------------
  # keep track of the number of leaf clusters seen so far
  return cl
}

"""

Note the trace when  `watch=1` over a data set with  93 rows.
Observe how, at the top-level, it works from _1,47_ then _48,93_
(the last number of each line is the number of examples in that split):

      1:  1,47,1,47,#22
      1:  |..1,24,1,24,#8
      2:  |..1,24,25,47,#6
      3:  |..25,47,1,24,#0
      3:  |..25,47,25,47,#8
      4:  1,47,48,93,#25
      4:  |..1,24,48,70,#7
      5:  |..1,24,71,93,#3
      5:  |..25,47,48,70,#3
      5:  |..25,47,71,93,#12
      6:  48,93,1,47,#25
      6:  |..48,70,1,24,#0
      6:  |..48,70,25,47,#5
      7:  |..71,93,1,24,#16
      8:  |..71,93,25,47,#4
      8:  48,93,48,93,#21
      8:  |..48,70,48,70,#12
      9:  |..48,70,71,93,#6
     10:  |..71,93,48,70,#1
     10:  |..71,93,71,93,#2

Here's some helper code. For each leaf cluster it:

+ Creates one new table for each leaf
+ Adds the centroid for that new table to a global
  table called `centers` that holds all the centroids.

Code:

"""

function makeNewTable(has,cl,_Table0,_Tile,_Tables, 
		 z,one,d,row1,row2) {
  cl = cl*100
  makeTable(name0,cl,_Tables)
  z = colnum0["_ZZ"]  
  for(one in has) {
    d = has[one]
    copy(data0[d],row1)
    row1[z] = cl
    addRow(row1,_Tables[cl])
  }
  centroid(_Tables[cl],row2)
  row2[z] = cl
  addRow(row2,_Tables[centers])
}

"""

Note the last three lines of the above: it adds 
the centroid of the new cluster to the _centroids_ 
table (which is called `centers`).

## Demo Code

It prints the generated tables, including the `centers`
table. 

"""
function _tiles(   _Tables, t,centers,name) {
  resetSeed()
  t=0
  readcsv("data/nasa93dem.csv",t,_Tables)
  centers= tiles(_Tables,t)
  tableprint(_Tables[centers],"%5.3f")
  for(name in names) 
    if(name != t)
      tableprint(_Tables[name],"%5.3f")
}

# function _tiles1(   _Table) {
#  readcsv("data/autompg.csv",0,_Table)
#  tiles(_Table[0])
# }

"""
Here are the centroids from
[nasa93dem](https://raw.github.com/timm/auk/master/data/nasa93dem.csv), 
map onto an _(x,y)_ space.

<img width=500 src="http://unbox.org/open/trunk/573/13/fall/doc/img/nasa93Clusters26.png">

And here are the output (all the centroids and all the other clusters):
[tiles.out](https://raw.github.com/timm/auk/master/var/tiles.out)

Sample plotting data in a file called `mydata.sh`:

    gnuplot<<EOF
    set terminal postscript eps color "Helvetica" 15
    set size 0.33,0.33
    set xtics (0,0.2,0.4,0.6,0.8,1.0)
    set output "mydata.eps"
    set palette defined (0  "green", 1 "red")
    set nokey
    set title "my title"
    set style fill solid 1 noborder
    plot 'mydata.dat'  with circles linecolor palette
    EOF
    epstopdf "mydata.eps"

Works on three column tab-separated data:
    
     # $_XX     $_YY            log($_ZZ)
     0.108      0.00135895      7.82978
     0.271      0.0388626       5.96581
     0.348      0.0388626       5.98299
     0.316      0.0517694       6.16121
     0.364      0.0789048       6.70094
     0.431      0.0424838       6.03548
     0.699      6.14656e-07     5.44781
     0.463      0.0535279       5.22709
     0.438      0.0789048       6.32316

"""
