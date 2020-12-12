#!/usr/bin/env bash
### configuration
##  where to write the generated code
Lib=$HOME/opt/share/awk

## Where to get missing files
Repo="https://raw.githubusercontent.com/timm/auk/master"


### end configuration

usage() {  tput bold; tput setaf 6; cat <<'EOF'
AUK: a preprocessor for AWK code
(c) 2020 MIT License, Tim Menzies timm@ieee.org

         .-"-.
       /  ,~a\_
       \  \__))>  a little auk (awk) goes a long way
       ,) ." \    
      /  (    \
     /   )    ;
    /   /     /
  ,/_."`  _.-`
   /_/`"\\___
        `~~~`

EOF
  tput sgr0; tput setaf 7; cat<<'EOF'
Augments standard gawk with polymorphism, encapsulation, 
objects, attributes, methods, iterators, multi-line comments.

INSTALL:
   chmod +x auk.sh; ./auk.sh -i

USAGE:
  ./auk.sh                converts all .auk files to .awk 
  ./auk.sh -h             as above, also prints this help text
  ./auk.sh xx.auk         as above, then runs xx.awk
  ./auk.sh xx             ditto
  Com | ./auk.sh xx.auk   as above, taking input from Com
  Com | ./auk.sh xx       ditto
  . auk.sh                adds some bash tools to local enviroment

Alternatively, to execute your source file directly using ./xx.auk,
chmod +x xx.auk and add the top line:

  #!/usr/bin/env path2auk.sh

If called via ". auk.sh" then the following alias are defined:
EOF
  tput setaf 9; echo ""
  gawk 'sub(/^[ \t]*alias/,"alias") {print $0}' $Auk/auk.sh
  tput sgr0
}
Auk=$(cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
exists() {
  want=$Auk/$1
  if [ -f "$want" ]; then
     true
  else
    echo "Downloading $1..."
    mkdir -p $(dirname $want) 
    curl -s $Repo/$1 -output $want
  fi
}

mkdir -p $Lib

exists src/auk.awk
cp $Auk/src/auk.awk $Lib

for i in *.auk $Auk/src/*.auk $Auk/tests/*.auk ; do
  f=$i
  g=$(basename $f)
  g=$Lib/${g%.*}.awk
  if [ "$f" -nt "$g" ]; then 
     gawk -f $Lib/auk.awk --source 'BEGIN { auk2awk("'$f'")}' > $g 
  fi
done


if [ "$1" == "-h" ]; then
  usage
elif [ "$1" == "-t" ]; then
  cd $Auk/tests
  $Auk/auk.sh $2.auk
elif [ "$1" == "-T" ]; then
  cd $Auk/tests
  $Auk/auk.sh tests.auk
elif [ "$1" == "-i" ]; then
  exists src/auk.awk
  exists tests/tests.auk
  exists .travis.yml
  exists .gitignore
  exists etc/.tmux.conf
  exists etc/.vimrc
  if [ ! -d "$HOME/.vim/bundle" ]; then
     git clone https://github.com/VundleVim/Vundle.vim.git \
           ~/.vim/bundle/Vundle.vim
     vims
  fi
  vim +PluginInstall +qall
elif [ -n "$1" ]; then
  f=$1
  g=$(basename $f)
  g=$Lib/${g%.*}.awk
  shift
  AWKPATH="$Lib:./:$AWKPATH"
  COM="gawk -f $Lib/auk.awk -f $g $*"
  if [ -t 0 ]
    then         AWKPATH="$AWKPATH" $COM
    else cat - | AWKPATH="$AWKPATH" $COM
  fi
else
  alias auk='$Auk/auk.sh '                 # short cut to this code
  alias gp='git add *; git commit -am save;git push;git status' # end-of-day actions
  alias gs='git status'                         # status 
  alias ls='ls -G'                              # ls
  alias reload='. $Auk/auk.sh'                     # reload these tools
  alias vims="vim +PluginInstall +qall"         # install vim plugins 
  alias vi="vim -u $Auk/etc/.vimrc"             # run a configured vim
fi
