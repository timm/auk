<img align=right width=250
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



Auk adds  the following goodies to standard Gawk:
         polymorphism, encapsulation, objects, 
attributes, methods, iterators, unit tests, multi-line comments.


Strange to say, most of that comes from 
[13 lines of a Gawk transpiler](https://github.com/timm/auk/blob/master/auk.awk#L13-L26)
from Auk code into the standard Gawk syntax.
Indeed, [a little auk (awk) goes a long  way](etc/img/littleaukhabitat.png)

## INSTALL:

- Install everything in [requirements.txt](requirements.txt).
- See [INSTALL.md](INSTALL.md)

 

## USAGE:

|com|notes|
|---|-----|
|  ./auk.sh              | convert .awk files in src and test to shared|
|  ./auk.sh -h           | as above, also prints this help text|
|  ./auk.sh xx.awk       | as above, then runs xx.awk|
|  ./auk.sh xx           | ditto|
|  Com \| ./auk.sh xx.awk | as above, taking input from Com|
|  Com \| ./auk.sh xx     | ditto|
|  . auk.sh               |adds some bash tools to local enviroment|

Alternatively, to execute your source file directly using ./xx.awk,
chmod +x xx.awk and add the top line:

      #!/usr/bin/env path2auk.sh

If called via ". auk.sh" then the following alias are defined:

```
  Auk= directory of auk.sh
  alias auk='$Auk/auk.sh '                 # short cut to this code
  alias gp='git add *;git commit -am save;git push;git status' # gh stuff
  alias gs='git status'                    # status 
  alias ls='ls -G'                         # ls
  alias reload='. $Auk/auk.sh'             # reload these tools
  alias vims="vim +PluginInstall +qall"    # install vim plugins 
  alias vi="vim -u $Auk/etc/.vimrc"        # run a configured vim
```  
