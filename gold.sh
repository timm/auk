#!/usr/bin/env bash 

####------------------------------------------------------------
## configuration

##  where to write the generated code
Lib=$HOME/opt/share/awk

## Where to get missing files
Repo="https://raw.githubusercontent.com/timm/gold/master"

## install directory for gold. defaults to where the gold.sh is
Gold=$(cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )

## where to find code to compile
Golds="$Gold/src $Gold/tests"

### end configuration

####------------------------------------------------------------
## help noted

usage() {  tput bold; tput setaf 6; cat <<'EOF'
GOLD: a preprocessor for AWK code
(c) 2020 MIT License, Tim Menzies timm@ieee.org

        _.-'~~`~~'-._
     .'`  J   E   C  `'.
    / B               T \
  /`       .-'~"-.       `\
 ; O      / `-    \      S ;
;        />  `.  -.|        ;
|       /_     '-.__)       |
|        |-  _.' \ |        |
;        `~~;     \\        ;
 ; IN GAWK  /      \\)P    ;
  \WE TRUST '.___.-'`"     /
   `\                   /`
     '._   2 0 2 0   _.'
 jgs    `'-..,,,..-'`

EOF
  tput sgr0; tput setaf 7; cat<<'EOF'
Augments standard gawk with polymorphism, encapsulation, objects, 
attributes, methods, iterators, unit tests, multi-line comments.

INSTALL:
   chmod +x gold.sh; ./gold.sh -i

USAGE:
  ./gold.sh               convert .awk files in src and test to shared
  ./gold.sh -h            as above, also prints this help text
  ./gold.sh xx.awk        as above, then runs xx.awk
  ./gold.sh xx            ditto
  Com | ./gold.sh xx.awk  as above, taking input from Com
  Com | ./gold.sh xx      ditto
  . gold.sh               adds some bash tools to local enviroment

Alternatively, to execute your source file directly using ./xx.awk,
chmod +x xx.awk and add the top line:

  #!/usr/bin/env path2gold.sh

If called via ". gold.sh" then the following alias are defined:
EOF
  tput setaf 9; echo ""
  awk 'sub(/^[ \t]*alias/,"alias") {print $0}' $Gold/gold.sh
  tput sgr0
}

####------------------------------------------------------------
## support code

## ensure file exists, or get download it from $Repo
exists() {
  want=$Gold/$1
  if [ -f "$want" ]; then
     true
  else
    echo "Downloading $1..."
    mkdir -p $(dirname $want) 
    curl -s $Repo/$1 -o $want
  fi
}

## any line containing FAIL or PASS gets shown in RED or GREEN
redgreen() { awk '
     /^---/ { $0="\033[01;36m"$0"\033[0m" }
     /FAIL/ { bad++; $0="\033[31m"$0"\033[0m" }
     /PASS/ { $0="\033[32m"$0"\033[0m" }
            { print $0                 }
     END    { exit bad!=0 }'
}

####------------------------------------------------------------
## ensure base system exists

mkdir -p $Lib

exists gold.awk
cp $Gold/gold.awk $Lib

####------------------------------------------------------------
## transpile all code in $Golds to $Lib

for i in $(find $Golds -name "*.awk"); do
  f=$i
  g=$(basename $f)
  g=$Lib/${g%.*}.awk
  if [ "$f" -nt "$g" ]; then 
     awk -f $Lib/gold.awk --source 'BEGIN { gold2awk("'$f'")}' > $g 
  fi
done

####------------------------------------------------------------
## process command line

## show help test
if [ "$1" == "-h" ]; then
  usage

## test one file in $Gold/tests
elif [ "$1" == "-t" ]; then
  cd $Gold/tests
  $Gold/gold.sh $2.awk | redgreen
  exit $?

## test all files in $Gold/tests, 
elif [ "$1" == "-T" ]; then
  cd $Gold/tests
  $Gold/gold.sh tests.awk | redgreen
  exit $?

## install lots of important files
elif [ "$1" == "-i" ]; then
  exists gold.awk
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

## profile a .awk file 
elif [ "$1" == "-p" ]; then
  f=$2
  g=$(basename $f)
  g=$Lib/${g%.*}.awk
  shift; shift
  AWKPATH="$Lib:./:$AWKPATH"
  COM="awk -p -f $Lib/gold.awk -f $g $*"
  if [ -t 0 ]
    then         AWKPATH="$AWKPATH" $COM
    else cat - | AWKPATH="$AWKPATH" $COM
  fi

## run a .awk file 
elif [ -n "$1" ]; then
  f=$1
  g=$(basename $f)
  g=$Lib/${g%.*}.awk
  shift
  AWKPATH="$Lib:./:$AWKPATH"
  COM="awk -f $Lib/gold.awk -f $g $*"
  if [ -t 0 ]
    then         AWKPATH="$AWKPATH" $COM
    else cat - | AWKPATH="$AWKPATH" $COM
  fi

## if none of the above, install some cool Bash toys
else
  alias gold='$Gold/gold.sh '                 # short cut to this code
  alias gp='git add *;git commit -am save;git push;git status' # gh stuff
  alias gs='git status'                    # status 
  alias ls='ls -G'                         # ls
  alias reload='. $Gold/gold.sh'             # reload these tools
  alias vims="vim +PluginInstall +qall"    # install vim plugins 
  alias vi="vim -u $Gold/etc/.vimrc"        # run a configured vim
fi
