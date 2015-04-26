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
		-o $(PAPER)/out/paper.tex \
		$(PAPER)/paper.pdc yaml/$(FORMAT).yaml
	pdflatex -output-directory=$(PAPER)/out $(PAPER)/out/paper.tex
	biber --nolog --output-directory $(PAPER)/out $(PAPER)/out/paper
	pdflatex -output-directory=$(PAPER)/out $(PAPER)/out/paper.tex
	biber --nolog --output-directory $(PAPER)/out $(PAPER)/out/paper
	pdflatex -output-directory=$(PAPER)/out $(PAPER)/out/paper.tex


pdf : $(PAPER)/paper.pdc
	pandoc --bibliography $(PAPER)/references.bib --filter pandoc-citeproc \
		--csl csl/$(FORMAT).csl --template=templates/$(FORMAT).latex \
		-o $(PAPER)/out/paper_panonly.pdf $(PAPER)/paper.pdc yaml/$(FORMAT).yaml

docx: $(PAPER)/paper.pdc
	pandoc --bibliography=$(PAPER)/references.bib --csl=csl/$(FORMAT).csl \
		--reference-docx=templates/$(FORMAT).docx -o $(PAPER)/out/paper.docx \
		$(PAPER)/paper.pdc yaml/$(FORMAT).yaml

clean:
	-cd $(PAPER)/out && $(RM) *.aux *.bbl *.bcf *.log *.run.xml *.out
