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
  c(
    "tidyverse",
    "tidylog",
    "fs",
    "vroom",
    "here",
    "CoordinateCleaner",
    "future",
    "furrr",
    "parallel",
    "doParallel"
  )
)

# plan
plan(multiprocess)


############################################################
#                                                          #
#                     process bien csv                     #
#                                                          #
############################################################

process_bien_csv <- function(csv){

  df_clean <-
    read_csv(
      file = csv,
      col_types = cols_only(
        scrubbed_species_binomial = "c",
        latitude = "d",
        longitude = "d"
      )
    ) %>%
    rename(species = scrubbed_species_binomial) %>%
    select(species, latitude, longitude) %>%
    group_by(species) %>%
    distinct(latitude, longitude, .keep_all = TRUE) %>%
    ungroup()

  return(df_clean)

}


# process files
occ_bien_raw <-
  dir_info(
    path = here("data", "raw_bien_occurrences"),
    regexp = "\\.csv"
  ) %>%
  filter(size != 0) %>%
  pull(path) %>%
  future_map_dfr(
    .x = .,
    .f = process_bien_csv,
    .progress = TRUE
  )


############################################################
#                                                          #
#                     process gbif csv                     #
#                                                          #
############################################################

process_gbif_csv <- function(csv){

  df_clean <-
    read_csv(
      file = csv,
      col_types = cols_only(
        species = "c",
        decimalLatitude = "d",
        decimalLongitude = "d"
      )
    ) %>%
    rename(
      latitude = decimalLatitude,
      longitude = decimalLongitude
    ) %>%
    select(species, latitude, longitude) %>%
    group_by(species) %>%
    distinct(latitude, longitude, .keep_all = TRUE) %>%
    ungroup()

  return(df_clean)

}


occ_gbif_raw <-
  dir_info(
    path = here("data", "raw_gbif_occurrences"),
    regexp = "\\.csv"
  ) %>%
  filter(size > 3) %>%
  pull(path) %>%
  map_dfr(
    .x = .,
    .f = possibly(
      .f = process_gbif_csv,
      otherwise = NULL,
      quiet = FALSE
    )
  )



############################################################
#                                                          #
#                    bind bien and gbif                    #
#                                                          #
############################################################

occ_all_raw <-
  bind_rows(occ_bien_raw, occ_gbif_raw) %>%
  group_by(species) %>%
  distinct(latitude, longitude, .keep_all = TRUE) %>%
  filter(n() >= 10) %>%
  ungroup() %>%
  drop_na()

############################################################
#                                                          #
#                    check coordinates                     #
#                                                          #
############################################################

occ_all_clean <-
  occ_all_raw %>%
  cc_dupl(lon = "longitude", lat = "latitude", species = "species") %>%
  cc_val(lon  = "longitude", lat = "latitude") %>%
  cc_zero(lon = "longitude", lat = "latitude") %>%
  cc_equ(lon  = "longitude", lat = "latitude") %>%
  cc_cap(lon  = "longitude", lat = "latitude", species = "species") %>%
  cc_gbif(lon = "longitude", lat = "latitude", species = "species") %>%
  cc_inst(lon = "longitude", lat = "latitude", species = "species") %>%
  cc_outl(lon = "longitude", lat = "latitude", species = "species") %>%
  cc_sea(lon  = "longitude", lat = "latitude", speedup = TRUE)

############################################################
#                                                          #
#                        save data                         #
#                                                          #
############################################################

write_csv(occ_all_clean, here("data", "species_all_cleaned_occ.csv"))
