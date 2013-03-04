Environment
===========
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

Building
========
To build:

	$ make


Notes
=====
Signatures
----------
To build PDF with blank signatures lines, ensure signatures.png does
not exist. To include signed signatures lines, place a closely cropped
signatures.png file into the directory containing the main thesis.tex.

