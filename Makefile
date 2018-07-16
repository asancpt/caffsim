cran: pkgdown rd2pdf
	R CMD check --as-cran ../caffsim_*.tar.gz ;\ 
	mv ../caffsim_*.tar.gz releases/

roxygen: 
	Rscript -e "library(caffsim);roxygen2::roxygenise()" 

build: roxygen
	Rscript -e "devtools::build()" 

pkgdown: build
	rm -rf docs ;\
	Rscript -e "Sys.setlocale('LC_ALL', 'C'); pkgdown::build_site()"

rd2pdf:
	cd ..; rm caffsim.pdf caffsim/inst/doc/caffsim.pdf; R CMD Rd2pdf caffsim; cp caffsim.pdf caffsim/inst/doc/caffsim.pdf

readme: 
	Rscript -e "rmarkdown::render('README.Rmd', output_format = 'github_document')"

