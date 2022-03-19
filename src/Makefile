opt=$(HOME)/opt/awk
awk=$(shell which gawk)

D   = ..
AUK = $(shell ls *.auk)
AWK = $(addsuffix .awk, $(addprefix $(opt)/,$(basename $(AUK))))

COMMENT= $(awk) '/^[ \t]*$$/ {next} {print "#     "$$0} END{print}'

all: $(AWK)

help:
	@printf "\nmake [OPTIONS]\n\nOPTIONS:\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%10s :\033[0m %s\n", $$1, $$2}'

h1:; @figlet -W -flarry3d     $t | $(COMMENT)
h3:; @figlet -W -fthreepoint   t | $(COMMENT)
h2:; @figlet -W -fcybermedium $t | $(COMMENT)

ok:
	mkdir -p $(opt)

$(opt)/%.awk : %.auk  Makefile 
	@echo "awk-ing $< ==> $@"
	@$(awk) -f auk.awk --source 'BEGIN {gold2awk("$<")}' > $@
