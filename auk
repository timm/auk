#  -*- sh -*-
export Here=$(pwd)
export Etc=$Here/etc
export Src=$Here/src
export Lib=$HOME/opt/auk/lib
export Tmp=$HOME/opt/auk/tmp  
export Bin=$Here/bin
export PATH="$Bin:$PATH"

if    [ -z "$*" ] 
then  echo "This is Auk (copyleft 2013 tim@menzies.us)"
	  echo "(and a little auk goes a long way)"
	  echo ""
	  bash --init-file $Etc/boot.sh -i
else  bash  -c ". $Etc/boot.sh; $*"
fi

# to do:
# markdown
# web server
# line, appends next line
