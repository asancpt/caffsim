rd2pdf:
	rm caffsim.pdf inst/doc/caffsim.pdf; cd ..; R CMD Rd2pdf caffsim; cp caffsim.pdf caffsim/inst/doc/caffsim.pdf

pkgdown:
	rm -rf docs;Rscript -e "Sys.setlocale('LC_ALL', 'C'); pkgdown::build_site()" 

roxygen:
	Rscript -e "library(caffsim);roxygen2::roxygenise()" 

CRAN:
	make roxygen; make rd2pdf; Rscript -e "devtools::build()"; R CMD check --as-cran ../caffsim_*.tar.gz; mv ../caffsim_*.tar.gz releases

readme:
	Rscript -e "rmarkdown::render('README.Rmd')"
