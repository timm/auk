BEGIN{ FS="," ; want="1,2,3"; Y=3; Log=0}

NR==1 { hi=-1*10^32; lo= -1*hi
        split(want,order,",") 
	for(i in order) 
	  if (order[i] < 0)
	    order[i] += 1 + NF 
	print "#" $order[1],$order[2],$order[3]
	Title=$order[3]
	next
}
{   N++
	x[N]=     $order[1]
	y[N]=     $order[2]
	tmp = $order[3] + 0
	if(Log) tmp=log(tmp)
	z[N] = tmp
	if (tmp>hi) hi = tmp 
	if (tmp<lo) lo = tmp
}
END {
	OFS="\t"
	range = hi - lo + 0.000001
	for(i=1;i<=N;i++)  
	  print x[i],y[i]^Y, raw= int(100*(z[i] - lo)/range)
	if(Log) {
	  lo = 2.718^lo
	  hi = 2.718^hi
	}
	printf("# set title \"'%s' = %s .. %s\"\n",Title,lo,hi)
}
