@include "lib.awk"

"""
About
-----

Inputs a list of numbers. Prints a string showing the _nth_ percentile chops of that number. Mark the median value with _"*"_. Mark the point
halfway between mix and max with _"|"_.

Also add at end of each line the _median_, the _IQR_ (inter-quartile range; 75-25th percentile) and the _max_ value. 
For example, in the last line shown below:

+ median = 0.69
+ the IQR is 0.39
+ the max is 1.0

For example give two lists that are the square and square root of 1000 random numbers 0..1, then:

<font size=2>

           square,  >, --       *         |-----------         , <,  0.01,  0.09,  0.26,  0.50,  0.82, |, 0.26, 0.51, 1.00
       squareRoot,  >,           ---------|      *     ----    , <,  0.29,  0.54,  0.69,  0.83,  0.94, |, 0.69, 0.39, 1.00

</font>


Arguments
---------

+ `lst` : the numbers. Need not be sorted.
+ `chops`: a list of key-value pairs where:
     +  _key_ is where to divide the data
     + _value_ is what mark to add to that region of the data.
     + For example, the above lines were generated using
             + 0.1 = "-"
             + 0.3 = " "
             + 0.5 = " "
             + 0.7 = "-"
+ `width` is the width of the display. In the above, `width=40`.
+ `form` is the format rule for real numbers. In the above, `form="%3.2f"`
+ `lo,hi` are the maximum points to show on the display. In the above, `lo=0, hi=1`.

Pragmatics
----------

I found this surprisingly tricky to code _until_ I stumbled onto the following tricks:

1.  Build a string `width` characters wide that is all blanks.
     Then write stuff into that string. This string then became a working memory in which I could write things in any order.
2.  Add in the special marks (_"*"_, _"|"_) after adding in the marks for the various percentiles.
3. Use `chops` to tune the presentation (e.g. by using different chops, I can do quartiles, quntiles, etc).

Code
----

### ptile

"""

function ptile(lst,chops,width,form, lo,hi,   \
              bar,sorted,p,who,where,wheres0,   \
              wheres,i,j,n,w,out,start,stop,\
              median,spread,max) {
    lo    =="" ? lo=0          : lo
    hi    =="" ? hi=100        : hi
    form  =="" ? form=" %3.0f" : form
    width =="" ? width=50      : width;print width
    bar   ="|"   
    for(i=1;i<=width;i++) 
        out[i] = " "
    n=asort(lst,sorted)
    for(p in chops) {  
        who[p] = sorted[int(p*n) ]
        where  = int(width*(who[p] - lo)/(hi-lo))
        wheres0[p]["x"] = where       
        wheres0[p]["*"] = chops[p]
    }
    w=asort(wheres0,wheres,"xsort")
    for(i=1;i<=w;i++) {
        start = wheres[i]["x"]
        stop  = i==w ? width : wheres[i+1]["x"]
        for(j=start;j<=stop;j++)
            out[j] = wheres[i]["*"]
    }
    out[int(width/2)] = bar
    median  = sorted[int(0.5*n)]
    spread  = sorted[int(0.75*n)] - sorted[int(0.25*n)]
    max     = sorted[n]
    where      = int(width*(median - lo)/(hi - lo))
    out[where] = "*" 
    asort(who)
    return ">,"l2s(out,"") ",<, " l2s(who,", ",form)\
        sprintf(",|," form "," form "," form,\
                median,spread,max)
}
 
"""

### Demo code

"""


function _ptile(      i,lst,lst2,lst3, lst4, chops1,chops2,com) {
  resetSeed(1)
  for(i=1;i<=1000;i++)  lst[i] = rand()^2
  for(i=1;i<=1000;i++)  lst4[i] = rand()^0.5
  pairs("1,0.51,2,0.49,3,0.48,4,0.52,5,0.52,6,0.48,"\
        "7,0.49,8,0.51,9,0.52,100,0.48", lst2)
   pairs("1,0.81,2,0.82,3,0.80,4,0.79,5,0.78,6,0.8,"\
        "7,0.81,8,0.82,9,0.79,100,0.78", lst3)
  pairs("0.1,-,0.3, ,0.5, ,0.7,-,0.9, ",chops1)
  pairs("0.25,-,0.5,-,0.75, "          ,chops2)
  com = "gawk -f malign.awk " # rand()
  #print "rx1,",ptile(lst,chops1,50,"%3.2f",0,1) | com
  print "square,"    ,ptile(lst, chops1,40,"%3.2f",0,1) | com
  print "squareRoot,",ptile(lst4,chops1,40,"%3.2f",0,1) | com
  #print "rx4,",ptile(lst2,chops2,40,"%3.2f",0.45,0.85) | com
 #print "rx5,",ptile(lst3,chops2,40,"%3.2f",0.45,0.83) | com
  close(com)
}
