Files = $(shell cd $(Src); ls *.auk)
Awks  = $(subst .auk,.awk,$(Lib)/$(subst .auk ,.awk $(Lib)/,$(Files)))

all : dirs hsed $(Awks)

dirs : ; @mkdir -p $(Lib) $(Tmp)

$(Lib)/%.awk : $(Src)/%.auk 
	@echo "making $(shell basename $@) ..."
	@gawk -f $(Etc)/auk2awk.awk $< | sed -f $(Tmp)/aukh.sed > $@

Hs=$(shell ls $(Src)/*.h)
hsed         : $(Tmp)/aukh.sed
$(Tmp)/aukh.sed : $(Hs)  $(Etc)/h2sed.awk
	-@rm -f $(Tmp)/aukh.all	
	@$(foreach f, $(Hs), \
		(echo "" ; cat $f ; echo "") >> $(Tmp)/aukh.all;  )	
	@gawk  -f $(Etc)/h2sed.awk $(Tmp)/aukh.all > $@
