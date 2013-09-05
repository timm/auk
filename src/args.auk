@include "lib.awk"

function args(str,opts,    out) { 
  return ARGC = args1(str,ARGV,ARGC,opts)
}

function args1(str,a,n,opts,    i,j,x,val,tmp) {
  n = n ? n : length(a)
  pairs(str,opts)
  i=0
  while(1) {
    if (i>n) break
    i++
    x = a[i]
    if (x=="--") continue 
    if (x !~ /^-/)  break
    if (! (x in opts)) 
      return barph(x" : undefined flag")    
    if (x ~ /^--/) {
       opts[x]= 1 - opts[x]
       continue
    }
    if (x ~ /^-/) {
      if (i >= n) 
        return barph(x" : missing arg")
      val = a[++i]
      opts[x] = numberp(val) ? val + 0 : val 
    }}
  for(j=i+1;j<=n;j++)  # copy to tmp, what's left on the input
    tmp[j-i]=a[j]
  split("",a,"")       # reset the input args
  for(j in tmp)        #  move the copy back to the input args
    a[j] = a[j] 
  return length(tmp)
}
function _args(   opts,n,str) {
  " test with 'demo args --open -g 0 -o src/args.auk' "
  args("-f,love,--open,1,-g,12,--h,0,-o,-",opts)
  while((getline str < opts["-o"]) > 0)
    print ++n, str
  o(opts,"opts")
}
