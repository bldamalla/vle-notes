## makefile for the final

content := $(wildcard content/*.tex)

all: main.tex $(content)
	latexmk -pdf --outdir=tmp/ main.tex
	mv tmp/main.pdf main.pdf

.PHONY: clean

clean:
	rm tmp/*

