#Very simple example of Make. See https://kbroman.org/minimal_make for more

manuscript.pdf: main.tex
	pdflatex -jobname=manuscript main.tex

 main.tex: linearModel.R scatterplot.R
	latex main.tex

linearModel.R: data/testdata.csv
	Rscript linearModel.R

scatterplot.R: data/testdata.csv
	Rscript scatterplot.R

