# ipak function: install and load multiple R packages.
# Check to see if packages are installed.
# Install them if they are not, then load them into the R session.
# https://gist.github.com/stevenworthington/3178163

ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
    {
      install.packages(new.pkg,
                       dependencies = TRUE,
                       repos = "https://cloud.r-project.org")
    }
    suppressPackageStartupMessages(sapply(pkg, require, character.only = TRUE))
}

ipak(packages_list <- c(
                       "devtools",  # required; do not exclude from this list
                       "bibtex",    # required; do not exclude from this list
                       "knitr",     # required; do not exclude from this list
                       "rmarkdown", # required; do not exclude from this list
                       "pacman",    # required; do not exclude from this list
                       "captioner", # required; do not exclude from this list
                       "git2r",     # required; do not exclude from this list
                       "googlesheets4",
                       "biogeo",    # optional; check again after geographic processing
                       "CoordinateCleaner",
                       "curl",
                       "dismo",
                       "dplyr",
                       "doParallel",
                       "fs",
                       "future",
                       "furrr",
                       "here",
                       "mapdata",
                       "maps",
                       "maptools",
                       "rgbif",
                       "rgeos",
                       "tidyr",
                       "parallel",
                       "purrr",
                       "raster",
                       "rgdal",
                       "sp",
                       "sqldf",
                       "taxize",
                       "tm",
                       "tidylog",
                       "vegan",
                       "vroom",
                       "rgbif"
                       )
     )

pacman::p_load_gh(char = c(
                           # required; do not exclude from this list
                           "benmarwick/wordcountaddin",
                           # required; do not exclude from this list
                           "ropensci/rcrossref"
                           ),
                  install = TRUE,
                  dependencies = TRUE)

write.bib(packages_list, "manuscript/sources/installed-r-packages.bib")

fig <- captioner(prefix ="Figure")
tab <- captioner(prefix="Table")
