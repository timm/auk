Data=${1:="showdat"}
Name=$(basename $Data)
Title=$(grep title ${Data}.dat | sed 's/#//')

mkdir -p $HOME/tmp

gnuplot<<EOF
set size square
set terminal postscript eps color "Helvetica" 10
set size 0.5,0.5
set noxtics 
set noytics 
set output "$HOME/tmp/${Name}.eps"
#set palette defined (0  "red", 0.5 "green",  1 "blue")
set palette model HSV
set palette defined ( 0 0 1 1, 1 1 1 1 )
set palette defined ( 0 0 1 0, 1 0 1 1, 6 0.8333 1 1, 7 0.8333 0 1)
set nokey
$Title
set style fill transparent solid 0.8 noborder
plot '${Data}.dat'  with circles linecolor palette
EOF
epstopdf "$HOME/tmp/${Name}.eps"
echo $HOME/tmp/$Name.pdf
