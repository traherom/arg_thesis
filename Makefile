all : thesis.pdf

test : all
	evince thesis.pdf &

clean : clean-temp
	rm -f thesis.pdf

clean-temp : 
	rm -f *.aux *.log *.blg *.bbl *.out *.lot *.lof *.toc *.aft

thesis.pdf : thesis.aux research.bbl
	pdflatex thesis
	pdflatex thesis

thesis.aux : thesis.tex chapter1.tex chapter2.tex chapter3.tex chapter4.tex chapter5.tex rfc.bib research.bib
	pdflatex thesis

research.bbl : research.bib thesis.aux
	bibtex thesis

research.bib : 
	ln -s ../papers/research.bib .

rfc.bib :
	wget http://www.tm.uka.de/~bless/rfc.bib
	
