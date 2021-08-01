## makefile for the final

ps-content := $(wildcard content/phase-split/*.tex)
plotsrc := $(wildcard figs/*.jl)
plots := $(plotsrc:figs/%.jl=figs/%.png)

default:
	echo "Pick between 'phase-split' and 'vle' to build PDF from source."

phase-split: phase-split.tex $(ps-content)
	latexmk -pdf --outdir=tmp/ phase-split.tex
	mv tmp/phase-split.pdf phase-split.pdf

figs/%.png: figs/%.jl
	julia --project $<

.PHONY: clean

clean:
	rm tmp/*

