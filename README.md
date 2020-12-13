<img align=right 
src="https://raw.githubusercontent.com/timm/auk/master/etc/img/littleauk.png">

# AUK= AWK + Goodies

[![DOI](https://zenodo.org/badge/318809834.svg)](https://zenodo.org/badge/latestdoi/318809834)  
![](https://img.shields.io/badge/platform-osx%20,%20linux-orange)    
![](https://img.shields.io/badge/language-gawk,bash-blue)  
![](https://img.shields.io/badge/purpose-ai%20,%20se-blueviolet)  
[![Build Status](https://travis-ci.com/timm/keys.svg?branch=main)](https://travis-ci.com/timm/keys)   
![](https://img.shields.io/badge/license-mit-lightgrey)  
[home](http://menzies.us/auk)  ::
[about](http://menzies.us/keys/about.html) ::
[lib](http://menzies.us/keys/lib.html) ::
[tips](http://menzies.us/keys/tips.html) 


A little auk (awk) goes a long way.
Auk adds 
         polymorphism, encapsulation, objects, 
attributes, methods, iterators, unit tests, multi-line comments
to standard Gawk

# INSTALL:

- Install everything in [requirements.txt](requirements.txt).
 
Download auk.sh and auk.awk from this repo

   auk=http://raw.githubusercontent.com/timm/auk/master/etc/img/littleauk.png
   curl -s $auk/auk.sh -o auk.sh
   cu
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

mkdir -p $Lib

exists auk.awk
cp $Auk/auk.awk $Lib

for i in $(find $Awks -name "*.awk"); do
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
  $Auk/auk.sh $2.awk
elif [ "$1" == "-T" ]; then
  cd $Auk/tests
  $Auk/auk.sh tests.awk | gawk '
     /^---/ { $0="\033[01;36m"$0"\033[0m" }
     /FAIL/ { bad++; $0="\033[31m"$0"\033[0m" }
     /PASS/ { $0="\033[32m"$0"\033[0m" }
            { print $0                 }
     END    { exit bad!=0 }'
    exit $?
elif [ "$1" == "-i" ]; then
  exists auk.awk
  exists tests/tests.awk
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
  alias gp='git add *;git commit -am save;git push;git status' # gh stuff
  alias gs='git status'                    # status 
  alias ls='ls -G'                         # ls
  alias reload='. $Auk/auk.sh'             # reload these tools
  alias vims="vim +PluginInstall +qall"    # install vim plugins 
  alias vi="vim -u $Auk/etc/.vimrc"        # run a configured vim
fi
