export Here=$(pwd)
export Etc="$Here/etc"
export Src="$Here"
export Lib="$HOME/opt/auk/lib"
export Tmp="$HOME/tmp/auk"  
export Bin="$HOME/bin"
export PATH="$Bin:$Lib:$PATH"
export AWKPATH="$Lib:$AWKPATH"
export Dot="$Etc/dotemacs"

mkdir -p $Lib $Tmp $Bin

here() { cd $1; basename $PWD; }

PROMPT_COMMAND='echo  -ne "AUX:\033]0;$(here ../..)/$(here ..)/$(here .)\007";PS1="$(here ../..)/$(here ..)/$(here .) \!> "'

e() {
    if   [ "$DISPLAY" ]
    then emacs -q -l "$Dot" $* & # for mulit-window environment
    else emacs -q -l "$Dot" $*   # for console environment
    fi
}
fake1() {
    if [ -f Makefile ]; then
        /usr/bin/make $*
        return 0
    fi
    if [ -f make.mk ]; then
        /usr/bin/make -f make.mk $*
        return 0
    fi
    echo "nothing to do"
}
fake() {
  root=$(git rev-parse --show-toplevel)
  if [ -n "$root" ]; then
    ( cd $root; fake1 $*)
  else
    /usr/bin/make $*
  fi
}
echo "This is Auk (copyleft 2013 tim@menzies.us)"
echo "(and a little auk goes a long, long way)"
echo ""
