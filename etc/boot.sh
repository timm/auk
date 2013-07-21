alias gauk="AWKPATH=$Lib pgawk --dump-variables=$Tmp/awkvars.out --profile=$Tmp/awkprof.out "
alias ls="ls --color"

dot=$PWD/etc/dotemacs

demo() {
    (cd $Here; make)
    f=$1; shift
    time gauk -f $f.awk --source 'BEGIN { exit _'$f'(); }' $*
	vars
}
e() {
    if   [ "$DISPLAY" ]
    then emacs -q -l $dot $* & # for mulit-window environment
    else emacs -q -l $dot $*   # for console environment
    fi
}
vars() {
    if [ -f "$Tmp/awkvars.out" ]
    then
		egrep -v '[A-Z][A-Z]' $Tmp/awkvars.out | 
    	sed 's/^/W> rogue local: /'
    fi
}
profile() {
    cat $Tmp/awkprof.out
}
here() { 
   cd $1; basename $PWD 
}
export PROMPT_COMMAND='echo  -ne "\033]0;AUK:$What: $(here ../..)/$(here ..)/$(here .)\007";PS1="AUK:$What: $(here ../..)/$(here ..)/$(here .) \! "'



