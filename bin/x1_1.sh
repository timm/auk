data() { gawk 'BEGIN {R='$1'; while(R-- > 0) {
              x=rand()
	            y=rand()
	            print x "\t" y "\t" x**1.1/(x+y) }}' 
	}

data 1000 > /tmp/dat
 
 gnuplot<<EOF
 set title  "x**1.1/(x+y)"
 set terminal pdf
 set output "x1_1.pdf"
 set yrange[0:1]
 set xrange[0:1]
 set nokey
 set palette defined (0  "red", 1 "green")
 set style fill solid 1 noborder
 plot "/tmp/dat"  with circles linecolor palette
EOF
