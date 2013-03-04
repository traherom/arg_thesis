Building
========
Environment
-----------
Needed tools:

- make
- pdflatex
- R
- dot/graphviz

R needs the following packages installed:

- knitr 
- plotrix
- coin
- gplots
- boot
- cluster

Make
----
To build:

	$ make

A thesis.pdf should be produced.

Notes
=====
Template
--------
This template has been slightly modified from the default AFIT template
to break content into separate files. A diff on the cls and thesis.tex
file should be done if a new version of the template is integrated.

Signatures
----------
To build PDF with blank signatures lines, ensure signatures.png does
not exist. To include signed signatures lines, place a closely cropped
signatures.png file into the directory containing the main thesis.tex.

