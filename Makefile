#Very simple example of Make. See https://kbroman.org/minimal_make for more

send_overleaf=git commit -m "auto commit from make" $^ $@;git push

manuscript.pdf: main.tex
	pdflatex -jobname=manuscript main.tex

main.tex: linearModel.R scatterplot.R
	Rscript linearModel.R
	Rscript scatterplot.R
	latex main.tex
	${send_overleaf}

linearModel.R: ./data/testdata.csv
	Rscript linearModel.R
	${send_overleaf}

scatterplot.R: ./data/testdata.csv
	Rscript scatterplot.R
	${send_overleaf}
