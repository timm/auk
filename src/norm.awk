BEGIN{ FS="," ; want="1,2,3"; Y=1; Log=0; Power=1; Inv=0}

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
	tmp = ($order[3] + 0)
	if(Inv) tmp = 1- tmp
	tmp = tmp**Power
	if(Log) tmp=log(tmp)
	#if(Log) print "#yes"
	z[N] = tmp
	if (tmp>hi) hi = tmp 
	if (tmp<lo) lo = tmp
}
END {
	OFS="\t"
	range = hi - lo + 0.000001
	for(i=1;i<=N;i++)  
	  print x[i],y[i]^Y, z[i] #raw= int(100*(z[i] - lo)/range)
	if(Log) {
	
	  Title="log(" Title ")"
	}
	if (Power ==1 )
	    printf("# set title \"%s\"\n",Title)
	else
	    printf("# set title \"%s^%s\"\n",Title,Power)
}
