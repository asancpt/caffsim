rd2pdf:
	rm caffsim.pdf;R CMD rd2pdf ../caffsim

pkgdown:
	rm -rf docs;Rscript -e "Sys.setlocale('LC_ALL', 'C'); pkgdown::build_site()" 

roxygen:
	Rscript -e "library(caffsim);roxygen2::roxygenise()" 

CRAN:
	make roxygen; make rd2pdf; Rscript -e "devtools::build()"; R CMD CHECK --as-cran ../caffsim_*.tar.gz; mv ../caffsim_*.tar.gz releases
