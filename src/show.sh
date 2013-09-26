Data=${1:="showdat"}
Name=$(basename $Data)
Title=$(grep title ${Data}.dat | sed 's/#//')
echo "[$Name]"
mkdir -p $HOME/tmp

gnuplot<<EOF
set size square
set terminal postscript eps color "Helvetica" 10
set size 0.33,0.33
#set noxtics 
#set noytics 
#set xrange [0:1]
#set yrange [0:1]
set xtics (0,0.2,0.4,0.6,0.8,1.0)
#set ytics (0,0.2,0.4,0.6,0.8,1.0)@
set output "$HOME/tmp/${Name}.eps"
set palette defined (0  "green", 1 "red")
#set palette model HSV
#set palette defined ( 0 0 1 1, 1 1 1 1 )
#set palette defined ( 0 0 1 0, 1 0 1 1, 6 0.8333 1 1, 7 0.8333 0 1)
set nokey
$Title
set style fill solid 1 noborder
plot '${Data}.dat'  with circles linecolor palette
EOF
epstopdf "$HOME/tmp/${Name}.eps"
echo $HOME/tmp/$Name.pdf
