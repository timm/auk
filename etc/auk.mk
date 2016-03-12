Gawk=$(shell which gawk)
Awks=$(shell ls *.awk)
Files=$(Lib)/$(subst .awk ,.awk $(Lib)/,$(Awks))
Libs=$(subst .awk,,$(Files))
apps="aa"


all : files

files: gauk $(Etc)/prep.sed $(Files)

gauk : $(Etc)/auk.mk
	echo "make files; AWKPATH='$(Tmp)' gawk --dump-variables='$(Tmp)/awkvars.out' --profile='$(Tmp)/awkprof.out' " "$$""*" > $@
	chmod +x $@

$(Tmp)/prep.sed : $(Etc)/h2sed.awk $(Awks)
	cat $(Awks) | grep '^#_ ' | gawk  -f $(Etc)/h2sed.awk  > $@

$(Tmp)/%.awk : %.awk $(Tmp)/prep.sed
	sed -f $(Tmp)/prep.sed $< > $@

vars :
	if  [ -f "$(Tmp)/awkvars.out" ] \
	then                             \
	  egrep -v '[A-Z][A-Z]' $(Etc)/awkvars.out | sed 's/^/W> rogue local: /' ; \
	fi

apps=aa
$(apps) : % : $(HOME)/git/timm/auk/%.awk 
	(echo "#!$(Gawk) -f "; cat $< ) > $@
	chmod +x $@

fred: $(apps)

typo:  ready 
	@- git status
	@- git commit -am "saving"
	@- git push origin master

commit:  ready 
	@- git status
	@- git commit -a 
	@- git push origin master

update:; @- git pull origin master
status:; @- git status

ready: gitting  

gitting:
	@git config --global credential.helper cache
	@git config credential.helper 'cache --timeout=3600'

your:
	@git config --global user.name "Your name"
	@git config --global user.email your@email.address

timm:
	@git config --global user.name "Tim Menzies"
	@git config --global user.email tim.menzies@gmail.com

