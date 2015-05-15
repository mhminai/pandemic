PAPER = paper_example
FORMAT = apa6
RM = /bin/rm

.PHONY: clean cleanall all

all : biblatex pdf docx Makefile

biblatex : $(PAPER)/paper.pdc
	pandoc -s --bibliography $(PAPER)/references.bib --biblatex \
		--template=templates/$(FORMAT).latex \
		--include-in-header=$(PAPER)/includes/after-header.tex \
		--include-before-body=$(PAPER)/includes/before-body.tex \
		--include-after-body=$(PAPER)/includes/after-body.tex \
		-o $(PAPER)/out/paper-$(FORMAT).tex \
		$(PAPER)/paper.pdc yaml/$(FORMAT).yaml
	pdflatex -output-directory=$(PAPER)/out $(PAPER)/out/paper-$(FORMAT).tex
	biber --nolog --output-directory $(PAPER)/out $(PAPER)/out/paper-$(FORMAT)
	pdflatex -output-directory=$(PAPER)/out $(PAPER)/out/paper-$(FORMAT).tex
	biber --nolog --output-directory $(PAPER)/out $(PAPER)/out/paper-$(FORMAT)
	pdflatex -output-directory=$(PAPER)/out $(PAPER)/out/paper-$(FORMAT).tex

bibxel : $(PAPER)/paper.pdc
	pandoc -s --bibliography $(PAPER)/references.bib --biblatex \
		--latex-engine=xelatex \
		--template=templates/$(FORMAT).latex \
		--include-in-header=$(PAPER)/includes/after-header.tex \
		--include-before-body=$(PAPER)/includes/before-body.tex \
		--include-after-body=$(PAPER)/includes/after-body.tex \
		-o $(PAPER)/out/paper-$(FORMAT).tex \
		$(PAPER)/paper.pdc yaml/$(FORMAT).yaml
	xelatex -output-directory=out out/paper_wp-memoir.tex
	biber --nolog --output-directory out out/paper_wp-memoir
	xelatex -output-directory=out out/paper_wp-memoir.tex
	biber --nolog --output-directory out out/paper_wp-memoir
	xelatex -output-directory=out out/paper_wp-memoir.tex


pdf : $(PAPER)/paper.pdc
	pandoc --bibliography $(PAPER)/references.bib --filter pandoc-citeproc \
		--csl csl/$(FORMAT).csl --template=templates/$(FORMAT).latex \
		-o $(PAPER)/out/paper_pan-$(FORMAT).pdf $(PAPER)/paper.pdc yaml/$(FORMAT).yaml

docx: $(PAPER)/paper.pdc
	pandoc --bibliography=$(PAPER)/references.bib --csl=csl/$(FORMAT).csl \
		--reference-docx=templates/$(FORMAT).docx -o $(PAPER)/out/paper-$(FORMAT).docx \
		$(PAPER)/paper.pdc yaml/$(FORMAT).yaml

clean:
	-cd $(PAPER)/out && $(RM) *.aux *.bbl *.bcf *.log *.run.xml *.out

cleanall:
	-cd out && $(RM) *
