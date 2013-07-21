#  -*- sh -*-
export What=transfer
export Here=$(pwd)
export Etc=$Here/etc
export Src=$Here/src
export Lib=$HOME/opt/auk/lib
export Tmp=$HOME/opt/auk/tmp  

if    [ -z "$*" ] 
then  bash --init-file $Etc/boot.sh -i
else  bash  -c ". $Etc/boot.sh; $*"
fi

# to do:
# markdown
# web server
# line, appends next line
