#!/usr/bin/env bash 

####------------------------------------------------------------
## configuration

##  where to write the generated code
Lib=$HOME/opt/share/awk

## Where to get missing files
Repo="https://raw.githubusercontent.com/timm/auk/master"

## install directory for auk. defaults to where the auk.sh is
Auk=$(cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )

## where to find code to compile
Awks="$Auk/src $Auk/tests"

### end configuration

####------------------------------------------------------------
## help noted

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
Augments standard gawk with polymorphism, encapsulation, objects, 
attributes, methods, iterators, unit tests, multi-line comments.

INSTALL:
   chmod +x auk.sh; ./auk.sh -i

USAGE:
  ./auk.sh               convert .awk files in src and test to shared
  ./auk.sh -h            as above, also prints this help text
  ./auk.sh xx.awk        as above, then runs xx.awk
  ./auk.sh xx            ditto
  Com | ./auk.sh xx.awk  as above, taking input from Com
  Com | ./auk.sh xx      ditto
  . auk.sh               adds some bash tools to local enviroment

Alternatively, to execute your source file directly using ./xx.awk,
chmod +x xx.awk and add the top line:

  #!/usr/bin/env path2auk.sh

If called via ". auk.sh" then the following alias are defined:
EOF
  tput setaf 9; echo ""
  gawk 'sub(/^[ \t]*alias/,"alias") {print $0}' $Auk/auk.sh
  tput sgr0
}

####------------------------------------------------------------
## support code

## ensure file exists, or get download it from $Repo
exists() {
  want=$Auk/$1
  if [ -f "$want" ]; then
     true
  else
    echo "Downloading $1..."
    mkdir -p $(dirname $want) 
    curl -s $Repo/$1 -o $want
  fi
}

## any line containing FAIL or PASS gets shown in RED or GREEN
redgreen() { gawk '
     /^---/ { $0="\033[01;36m"$0"\033[0m" }
     /FAIL/ { bad++; $0="\033[31m"$0"\033[0m" }
     /PASS/ { $0="\033[32m"$0"\033[0m" }
            { print $0                 }
     END    { exit bad!=0 }'
}

####------------------------------------------------------------
## ensure base system exists

mkdir -p $Lib

exists auk.awk
cp $Auk/auk.awk $Lib

####------------------------------------------------------------
## transpile all code in $Aws to $Lib

for i in $(find $Awks -name "*.awk"); do
  f=$i
  g=$(basename $f)
  g=$Lib/${g%.*}.awk
  if [ "$f" -nt "$g" ]; then 
     gawk -f $Lib/auk.awk --source 'BEGIN { auk2awk("'$f'")}' > $g 
  fi
done

####------------------------------------------------------------
## process command line

## show help test
if [ "$1" == "-h" ]; then
  usage

## test one file in $Auk/tests
elif [ "$1" == "-t" ]; then
  cd $Auk/tests
  $Auk/auk.sh $2.awk | redgreen
  exit $?

## test all files in $Auk/tests, 
elif [ "$1" == "-T" ]; then
  cd $Auk/tests
  $Auk/auk.sh tests.awk | redgreen
  exit $?

## install lots of important files
elif [ "$1" == "-i" ]; then
  exists auk.awk
  exists tests/tests.awk
  exists src/happy.awk
  exists src/happys.awk
  exists data/happys.csv
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

## run a .awk file 
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

## if none of the above, install some cool Bash toys
else
  alias auk='$Auk/auk.sh '                 # short cut to this code
  alias gp='git add *;git commit -am save;git push;git status' # gh stuff
  alias gs='git status'                    # status 
  alias ls='ls -G'                         # ls
  alias reload='. $Auk/auk.sh'             # reload these tools
  alias vims="vim +PluginInstall +qall"    # install vim plugins 
  alias vi="vim -u $Auk/etc/.vimrc"        # run a configured vim
fi
