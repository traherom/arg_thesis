temptex := $(patsubst %.Rnw,%.tex,$(wildcard *.Rnw))
thesis_files := thesis.tex abstract.tex acknowledgments.tex chapter1.tex chapter2.tex chapter3.tex chapter4.tex chapter5.tex chapter6.tex appendix_ip.tex appendix_protocol.tex appendix_argconf.tex appendix_generators.tex appendix_processor.tex appendix_tests.tex newcommands.tex rfc.bib research.bib acronyms.tex flow_director.pdf flow_packet_validation.pdf packet_structure.pdf results.csv
defense_files := defense.tex
diagrams := diagrams/*.pdf diagrams/*.dot

all : thesis defense

thesis : thesis.pdf

defense : thesis defense.pdf

test : all
	open thesis.pdf defense.pdf

clean : clean-temp
	rm -f thesis.pdf

clean-temp : 
	rm -f *.aux *.log *.blg *.bbl *.out *.lot *.lof *.toc *.aft
	rm -f *.nav *.snm
	rm -f $(temptex)
	rm -rf figure

thesis.pdf : thesis.aux
	pdflatex thesis
	pdflatex thesis

thesis.aux : $(thesis_files) $(diagrams)
	pdflatex -draftmode thesis
	bibtex thesis

watch : 
	makewatch $(thesis_files) chapter5.Rnw

# Download RFC bib if needed
rfc.bib :
	wget http://www.tm.uka.de/~bless/rfc.bib

# PDFs as images
%.pdf : %.tex
	pdflatex "$<"
	pdflatex "$<"

# Knitr for Rnw files
%.tex : %.Rnw
	R -e 'library("knitr"); knit("$<")'

# DOT .dot files (GraphViz)
%.png : diagrams/%.dot
	dot "$<" -Tpng -o "$@" 
%.pdf : diagrams/%.dot
	dot "$<" -Tps -o "$*.ps"
	ps2eps -f "$*.ps"
	ps2pdf -dEPSCrop "$*.eps" "$@"

