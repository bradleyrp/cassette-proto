#---CASSETTE MAKEFILE

#---always show the banner
-include banner

#---point latex to extra style files
export TEXINPUTS := .:./cas/sources/extras/:$(TEXINPUTS)

#---extra arguments passed along to downstream functions and scripts
RUN_ARGS := $(wordlist 1,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
#---ensure that we filter out all valid target names from RUN_ARGS
COMMENTS := $(filter-out all banner save push pull add start stop,$(RUN_ARGS))
#---evaluate all superfluous make arguments to suppress warnings that contain these arguments
$(eval $(COMMENTS):;@:)

#---parse downstream files
SRC_MD = $(filter-out text/bak.%,$(wildcard text/*.md))
OBJ_MD_HTML = $(patsubst text/%.md,cas/hold/%.html,$(SRC_MD))
OBJ_TEX_PDF = $(patsubst text/%.tex, cas/hold/%.pdf, $(SRC_TEX))

#---settings
latex_engine = pdflatex

#---standard
.PHONY: all banner save push pull add start stop
all: $(OBJ_MD_HTML) indexer

#---draw an index HTML
indexer:
	@python ./cas/parser/indexer.py
	@/bin/echo "[INDEX] file:///$(shell pwd)/index.html"


#---show the banner if no targets
banner:
	@sed -n 1,10p cas/readme.md
	@/bin/echo "[NOTE] use 'make help' for instructions"

#---print help from readme minus banner
help:
ifeq (,$(findstring save,${RUN_ARGS}))
	@/bin/echo -n "[STATUS] printing help: "
	tail -n +10 cas/readme.md
endif

#---remove holding directory and rendered files
clean:
	@/bin/echo -n "[STATUS] cleaning "
	rm -rf $(wildcard cas/hold) || true
	@/bin/echo -n "[STATUS] cleaning "
	rm -rf $(wildcard ./*.html) || true
	@/bin/echo -n "[STATUS] cleaning "
	rm -rf $(wildcard ./*.pdf) || true
	@/bin/echo -n "[STATUS] cleaning "
	rm -rf $(wildcard ./*.png) || true
	@/bin/echo -n "[STATUS] cleaning "
	rm -rf $(wildcard ./*.png) || true
	@/bin/echo -n "[STATUS] cleaning "
	rm -rf $(wildcard ./*.tex) || true

###---DOCUMENT

#---send markdown files to parser
cas/hold/%.html: text/%.md
	@test -d cas/hold || mkdir cas/hold
	@python ./cas/parser/parser.py $< > $(patsubst text/%.md,cas/hold/%.texlog,$<) 2>&1 || { tail -n 15 $(patsubst text/%.md,cas/hold/%.texlog,$<); exit 1; }
	@if [ -a $(patsubst cas/hold/%.html,cas/hold/%.pdf,$@) ]; then { cp $(patsubst cas/hold/%.html,cas/hold/%.pdf,$@) ./; }; fi;
	@if [ -a $(patsubst cas/hold/%.html,cas/hold/%.tex,$@) ]; then { cp $(patsubst cas/hold/%.html,cas/hold/%.tex,$@) ./; }; fi;
	@if grep "Fatal error" $(patsubst text/%.md,cas/hold/%.texlog,$<); then { echo ""; tail -n 15 $(patsubst text/%.md,cas/hold/%.texlog,$<); echo ""; echo "[ERROR] reported from $(patsubst text/%.md,cas/hold/%.texlog,$<)"; exit 1; } fi
	@/bin/echo "[STATUS] compiled $<"
	@/bin/echo "[READ] file:///$(shell pwd)/$(patsubst text/%.md,%.html,$<)"

###---VERSIONING

#---write commit messages directly on the command line
#---all other make targets are protected from executing save via ifeq findstring
save: banner
	@/bin/echo -n "[STATUS] saving changes: "
	bash cas/version/save.sh ${RUN_ARGS}
	@if [ false ]; then echo "[STATUS] done"; exit 0; else true; fi	

#---create a branch
start:
ifeq (,$(findstring save,${RUN_ARGS}))
	@/bin/echo -n "[STATUS] branching: "
	bash cas/version/start.sh ${RUN_ARGS}
	@if [ false ]; then echo "[STATUS] done"; exit 0; else true; fi	
endif

#---merge a branch with no fast forwards
stop:
ifeq (,$(findstring save,${RUN_ARGS}))
	@/bin/echo -n "[STATUS] merging: "
	bash cas/version/stop.sh ${RUN_ARGS}
	@if [ false ]; then echo "[STATUS] done"; exit 0; else true; fi	
endif

#---add a new file
add:
ifeq (,$(findstring save,${RUN_ARGS}))
	@/bin/echo -n "[STATUS] adding files via git add: "
	bash cas/version/add.sh ${RUN_ARGS}
	@if [ false ]; then echo "[STATUS] done"; exit 0; else true; fi	
endif

#---push changes to source
push:
ifeq (,$(findstring save,${RUN_ARGS}))
	@/bin/echo -n "[STATUS] pushing changes: "
	bash cas/version/push.sh ${RUN_ARGS}
	@if [ false ]; then echo "[STATUS] done"; exit 0; else true; fi	
endif

#---pull changes from source
pull:
ifeq (,$(findstring save,${RUN_ARGS}))
	@/bin/echo -n "[STATUS] pulling changes: "
	bash cas/version/pull.sh ${RUN_ARGS}
	@if [ false ]; then echo "[STATUS] done"; exit 0; else true; fi	
endif

#---get cassette code changes from another
getcode:
ifeq (,$(findstring save,${RUN_ARGS}))
	@/bin/echo -n "[STATUS] pulling code changes: "
	bash cas/version/getcode.sh ${RUN_ARGS}
	@if [ false ]; then echo "[STATUS] done"; exit 0; else true; fi	
endif
