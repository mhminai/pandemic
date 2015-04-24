OUT_DIR = out
CSL_DIR = csl
YAML_DIR = yaml
TMPL_DIR = templates
INCL_DIR = includes
FILE = paper
BIBFILE = references.bib
HD_INCL = after-header.tex
BDB_INCL = before-body.tex
BDA_INCL = after-body.tex
LATTMPL = apa6template.latex
#LATTMPL = aom-template.latex
YAML = apa.yaml
CSLFILE = apa.csl
REFDOCX = apa_styles.docx
RM = /bin/rm

.PHONY: clean cleanall all

all : biblatex pdf docx Makefile

biblatex : $(FILE).pdc
	pandoc -s --bibliography $(BIBFILE) --biblatex \
		--template=$(TMPL_DIR)/$(LATTMPL) \
		--include-in-header=$(INCL_DIR)/$(HD_INCL) \
		--include-before-body=$(INCL_DIR)/$(BDB_INCL) \
		--include-after-body=$(INCL_DIR)/$(BDA_INCL) -o $(OUT_DIR)/$(FILE).tex \
		$(YAML_DIR)/$(YAML) $(FILE).pdc
	pdflatex -output-directory=$(OUT_DIR) $(OUT_DIR)/$(FILE).tex
	biber --nolog --output-directory $(OUT_DIR) $(OUT_DIR)/$(FILE)
	pdflatex -output-directory=$(OUT_DIR) $(OUT_DIR)/$(FILE).tex
	biber --nolog --output-directory $(OUT_DIR) $(OUT_DIR)/$(FILE)
	pdflatex -output-directory=$(OUT_DIR) $(OUT_DIR)/$(FILE).tex


pdf : $(FILE).pdc
	pandoc --filter pandoc-citeproc --template=$(TMPL_DIR)/$(LATTMPL) \
		-o $(OUT_DIR)/$(FILE)_panonly.pdf $(YAML_DIR)/$(YAML) $(FILE).pdc

docx: $(FILE).pdc
	pandoc --bibliography=$(BIBFILE) --csl=$(CSL_DIR)/$(CSLFILE) \
		--reference-docx=$(TMPL_DIR)/$(REFDOCX) -o $(OUT_DIR)/$(FILE).docx \
		$(YAML_DIR)/$(YAML) $(FILE).pdc

clean:
	-cd $(OUT_DIR) && $(RM) *.aux *.bbl *.bcf *.blg *.log *.run.xml *.ttt \
		*.fls *.fdb_latexmk *.dvi *.out
