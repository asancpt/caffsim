rd2pdf:
	rm caffsim.pdf;R CMD rd2pdf ../caffsim

pkgdown:
	rm -rf docs;Rscript -e "Sys.setlocale('LC_ALL', 'C'); pkgdown::build_site()" 
