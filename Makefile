temptex := $(patsubst %.Rnw,%.tex,$(wildcard *.Rnw))

all : thesis.pdf

test : all
	echo $(wildcard chapter[1-6].tex)
	echo $(temptex)
	open thesis.pdf

clean : clean-temp
	rm -f thesis.pdf

clean-temp : 
	rm -f *.aux *.log *.blg *.bbl *.out *.lot *.lof *.toc *.aft
	rm -f $(temptex)

thesis.pdf : thesis.aux
	pdflatex thesis
	pdflatex thesis

thesis.aux : thesis.tex chapter1.tex chapter2.tex chapter3.tex chapter4.tex chapter5.tex chapter6.tex rfc.bib research.bib acronyms.tex
	pdflatex -draftmode thesis
	bibtex thesis

# Download RFC bib if needed
rfc.bib :
	wget http://www.tm.uka.de/~bless/rfc.bib

# Knitr for Rnw files
%.tex : %.Rnw
	R -e 'library("knitr"); knit("$<")'

