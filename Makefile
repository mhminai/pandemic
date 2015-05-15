PAPER = paper_example
FORMAT = apa6
RM = /bin/rm

.PHONY: clean cleanall all

all : biblatex pdf docx Makefile

biblatex : $(PAPER)/paper.pdc
	cd $(PAPER) && pandoc -s --bibliography references.bib --biblatex \
		--template ../templates/$(FORMAT).latex \
		--include-in-header=includes/after-header.tex \
		--include-before-body=includes/before-body.tex \
		--include-after-body=includes/after-body.tex \
		-o out/paper-$(FORMAT).tex \
		paper.pdc ../yaml/$(FORMAT).yaml
	cd $(PAPER) && pdflatex -output-directory=out out/paper-$(FORMAT).tex
	cd $(PAPER) && biber --nolog --output-directory out out/paper-$(FORMAT)
	cd $(PAPER) && pdflatex -output-directory=out out/paper-$(FORMAT).tex
	cd $(PAPER) && biber --nolog --output-directory out out/paper-$(FORMAT)
	cd $(PAPER) && pdflatex -output-directory=out out/paper-$(FORMAT).tex

bibxel : $(PAPER)/paper.pdc
	cd $(PAPER) && pandoc -s --bibliography references.bib --biblatex \
		--latex-engine=xelatex \
		--template ../templates/$(FORMAT).latex \
		--include-in-header=includes/after-header.tex \
		--include-before-body=includes/before-body.tex \
		--include-after-body=includes/after-body.tex \
		-o out/paper-$(FORMAT).tex \
		paper.pdc ../yaml/$(FORMAT).yaml
	cd $(PAPER) && xelatex -output-directory=out out/paper-$(FORMAT).tex
	cd $(PAPER) && biber --nolog --output-directory out out/paper-$(FORMAT)
	cd $(PAPER) && xelatex -output-directory=out out/paper-$(FORMAT).tex
	cd $(PAPER) && biber --nolog --output-directory out out/paper-$(FORMAT)
	cd $(PAPER) && xelatex -output-directory=out out/paper-$(FORMAT).tex


pdf : $(PAPER)/paper.pdc
	cd $(PAPER) && pandoc --bibliography references.bib --filter pandoc-citeproc \
		--csl ../csl/$(FORMAT).csl --template ../templates/$(FORMAT).latex \
		-o out/paper_pan-$(FORMAT).pdf paper.pdc ../yaml/$(FORMAT).yaml

docx: $(PAPER)/paper.pdc
	cd $(PAPER) && pandoc --bibliography=references.bib --csl=../csl/$(FORMAT).csl \
		--reference-docx=../templates/$(FORMAT).docx -o out/paper-$(FORMAT).docx \
		paper.pdc ../yaml/$(FORMAT).yaml

clean:
	-cd $(PAPER)/out && $(RM) *.aux *.bbl *.bcf *.log *.run.xml *.out *.synctex.gz

cleanall:
	-cd $(PAPER)/out && $(RM) *
