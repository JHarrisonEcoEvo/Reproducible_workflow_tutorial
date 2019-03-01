#Very simple example of Make. See https://kbroman.org/minimal_make for more

manuscript.pdf: main.tex scatterplot.R linearModel.R data/testdata.csv results/*
 pdflatex -jobname=manuscript main.tex

results/lm_results.tex: linearModel.R data/testdata.csv
	Rscript linearModel.R

results/scatterplot.pdf: scatterplot.R data/testdata.csv
	Rscript scatterplot.R

