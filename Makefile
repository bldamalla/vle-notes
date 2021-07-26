## makefile for the final

content := $(wildcard content/*.tex)
plotsrc := $(wildcard figs/*.jl)
plots := $(plotsrc:figs/%.jl=figs/%.png)

all: main.tex $(content) figs
	latexmk -pdf --outdir=tmp/ main.tex
	mv tmp/main.pdf main.pdf

figs: $(plots)


figs/%.png: figs/%.jl
	julia --project $<

.PHONY: clean

clean:
	rm tmp/*

