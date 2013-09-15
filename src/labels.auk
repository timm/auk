function discreteNames(names,num,out,   k,tmp) {
  for(k in names) {
    tmp = names[k]
    if (k in num)
      gsub(/[\$\-\+]/,"",tmp)
    out[k] = tmp }
}
function glabel(k,val,bins,b,_Table,   i) {
  val = (val - mu[k]) / sd[k]
  for(i=1;i < bins;i++) 
    if (val <= b[i]) 
      return i
  return bins
}
function ewdlabel(k,val,bins,b,_Table,   i) {
  val = (val - lo[k]) / (hi[k] - lo[k] + 0.00001)
  for(i=1;i < bins;i++) 
    if (val <= b[i]) 
      return i
  return bins
}
function ewdbreaks(a) {
  breaks0(a,"                                     0.50                                   ")
  breaks0(a,"                                0.33      0.67                              ") 
  breaks0(a,                                "0.25 0.50 0.75                              ") 
  breaks0(a,"                           0.20 0.40      0.60 0.80                         ") 
  breaks0(a,"                           0.17 0.33 0.50 0.67 0.83                         ") 
  breaks0(a,"                      0.14 0.29 0.43      0.57 0.71 0.86                    ") 
  breaks0(a,"                      0.12 0.25 0.38 0.50 0.62 0.75 0.88                    ") 
  breaks0(a,"                 0.11 0.22 0.33 0.44      0.56 0.67 0.78 0.89               ") 
  breaks0(a,"                 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90               ") 
  breaks0(a,"            0.09 0.18 0.27 0.36 0.45      0.55 0.64 0.73 0.82 0.91          ") 
  breaks0(a,"            0.08 0.17 0.25 0.33 0.42 0.50 0.58 0.67 0.75 0.83 0.92          ") 
  breaks0(a,"       0.08 0.15 0.23 0.31 0.38 0.46      0.54 0.62 0.69 0.77 0.85 0.92     ") 
  breaks0(a,"       0.07 0.14 0.21 0.29 0.36 0.43 0.50 0.57 0.64 0.71 0.79 0.86 0.93     ") 
  breaks0(a,"  0.07 0.13 0.20 0.27 0.33 0.40 0.47      0.53 0.60 0.67 0.73 0.80 0.87 0.93") 
  breaks0(a,  "0.06 0.12 0.19 0.25 0.31 0.38 0.44 0.50 0.56 0.62 0.69 0.75 0.81 0.88 0.94")
}
function gbreaks(a) {
  breaks0(a,"                        0                    ")
  breaks0(a,"                  -0.43   0.43               ")
  breaks0(a,"                  -0.67 0 0.67               ")
  breaks0(a,"            -0.84 -0.25   0.25 0.84          ")
  breaks0(a,"            -0.97 -0.43 0 0.43 0.97          ")
  breaks0(a,"      -1.07 -0.57 -0.18   0.18 0.57 1.07     ")
  breaks0(a,"      -1.15 -0.67 -0.32 0 0.32 0.67 1.15     ")
  breaks0(a,"-1.22 -0.76 -0.43 -0.14   0.14 0.43 0.76 1.22")
  breaks0(a,"-1.28 -0.84 -0.52 -0.25 0 0.25 0.52 0.84 1.28")
}
function breaks0(a,str,    i,tmp,n) {
  n = 1 + split(str,tmp," ")
  for(i in tmp)
    a[n][i] = tmp[i]
}
