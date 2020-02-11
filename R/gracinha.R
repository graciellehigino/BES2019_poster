# ipak function: install and load multiple R packages.
# Check to see if packages are installed. 
# Install them if they are not, then load them into the R session.
# Forked from: https://gist.github.com/stevenworthington/3178163
ipak <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)){
    install.packages(new.pkg, dependencies = TRUE)
  }
  suppressPackageStartupMessages(sapply(pkg, require, character.only = TRUE))
}

ipak(
  c("tidyverse",
    "tidylog",
    "future",
    "furrr",
    "parallel",
    "doParallel",
    "ncf",
    "sf"
  )
)

# plan
plan(multiprocess)

load("Downloads/gwr_total.Rdata")

############################################################
#                                                          #
#             SpatialPointsDataFrame to tibble             #
#                                                          #
############################################################

model_data <- 
  g.model %>% 
  furrr::future_map(~ st_as_sf(.x)) 

############################################################
#                                                          #
#                   extract coordinates                    #
#                                                          #
############################################################

model_coordinates <- 
  g.model %>% 
  furrr::future_map(~ st_as_sf(.x)) %>% 
  furrr::future_map(~ st_coordinates(.x)) %>% 
  furrr::future_map(~ as_tibble(.x))

############################################################
#                                                          #
#                bind data and coordinates                 #
#                                                          #
############################################################

model_table <- 
  furrr::future_map2(
    .x = model_data, 
    .y = model_coordinates, 
    .f = bind_cols
    ) %>% 
  furrr::future_map( ~select(.x, -geometry)) %>% 
  furrr::future_map( ~as_tibble(.x)) 

############################################################
#                                                          #
#                       run correlog                       #
#                                                          #
############################################################

model_correlog <- 
  model_table %>% 
  furrr::future_map(
    ~ ncf::correlog(
          x = .x$X,   
          y = .x$Y ,   
          z = .x$localR2,  # variável de interesse
          increment = 2
        ),  
    .progress = TRUE
    ) 

############################################################
#                                                          #
#                      plot correlog                       #
#                                                          #
############################################################

model_correlog %>% 
  map(~ plot(.x))

