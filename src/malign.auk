BEGIN { 
  Width=1;
  Gutter=1;
  OFS=FS=",";
}     
{ N++;  
  for(I=1;I<=NF;I++) {
    if( (L=length($I)) > Max[I]) Max[I]=L;
    ++Data[N,0];
    Data[N,I]=$I; }
}
END {
  for(J=1;J<=N;J++) {
    Str=Sep1="";
    if (Data[J,0]>1) {  
      for(I=1;I<=NF;I++) {
        L=length(Data[J,I]);
        Str = Str Sep1	                         \
	  str(most(Width,Max[I]+Gutter+1)-L," ")  \
	  Data[J,I];
        Sep1= OFS;
      }} 
    else {Str=Data[J,1]}
    print Str;}
}
function str(n,c,  out) { 
  while(--n > 0) out = out c; return out
}  
function most(x,y) { 
  return x > y ? x : y
}  
