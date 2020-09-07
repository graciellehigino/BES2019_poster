# Read CSV with urls for all data
#devtools::install_github("tidyverse/googlesheets4")
datasource <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1qq6YTTcAIZVI9olRVgSm5sKVlxuS-4yW-yD06TXJzgg/edit?usp=sharing")

# geting zip files from Data Papers

if(file.exists("data/raw/data.Rdata")){
  load("data/raw/data.Rdata")
} else {

  gbif<-occ_download_import(occ_download_get("0023533-180131172636756", path = "data/raw", overwrite = TRUE), quote = "")

  filenumbers <- 1:length(datasource$url)
  filenames <- paste0("data/raw/file", filenumbers, ".zip")

  for (i in 1:length(datasource$url)){
     files <-  list(download.file(datasource$url[i], filenames[i]))
     unzip(filenames[i], exdir = "data/raw")
     }
  rm(filenumbers, filenames, files)

  ## Amphibia - Datapapers
  amp_dp <- dplyr::inner_join(read.csv("data/raw/ATLANTIC_AMPHIBIANS_sites.csv"),
                  read.csv("data/raw/ATLANTIC_AMPHIBIANS_species.csv"), by = "id")

  ## Mammals
  # Bats
  bat_capture <- read.csv("data/raw/ATLANTIC_BATS_Capture.csv") # read data with species names
  cols <- strsplit(colnames(bat_capture), "[.]|[,]", fixed = FALSE) # creat column names vector to use on `separate`
  cols <-  cols[[1]][! cols[[1]] %in% ""]
  bat_capture <- tidyr::separate(bat_capture, 1, cols, sep = "[,]", remove = TRUE) # separate data in proper columns
  bat_sites <-  read.csv("data/raw/ATLANTIC_BATS_Study_site.csv") # read data with coordinates

  bat_dp <- dplyr::inner_join(bat_capture, bat_sites, by = "ID") # merge

  rm(cols, bat_capture, bat_sites)

  # Small Mammals
  mamsmall_site <- readr::read_csv("data/raw/ATLANTIC_SM_Study_Site.csv", col_names=FALSE)
  mamsmall_site[1,1] <- "ID."
  colnames(mamsmall_site) <- mamsmall_site[1,]

  mamsmall_capture <- readr::read_csv("data/raw/ATLANTIC_SM_Capture.csv", col_names=FALSE)
  mamsmall_capture[1,1] <- "ID."
  colnames(mamsmall_capture) <- mamsmall_capture[1,]

  mamsmall_dp <- dplyr::inner_join(mamsmall_site,mamsmall_capture, by = "ID.")
  rm(mamsmall_site,mamsmall_capture)

  # Camtraps Mammals
  loc <- read.csv("data/raw/ATLANTIC_CAMTRAPS_1-0_LOCATION.csv")
  survey <- read.csv("data/raw/ATLANTIC_CAMTRAPS_1-0_SURVEY.csv")
  records <- read.csv("data/raw/ATLANTIC_CAMTRAPS_1-0_RECORDS.csv")
  sp <- read.csv("data/raw/ATLANTIC_CAMTRAPS_1-0_SPECIES.csv")

  mamct_dp <- dplyr::inner_join(loc, survey, by = "location_id")
  mamct_dp <- dplyr::inner_join(mamct_dp, records, by = "survey_id")
  mamct_dp <- dplyr::inner_join(mamct_dp, sp, by = "species_id")

  rm(loc, survey, records, sp)

  # Primates
  mamprim_dp <-  read.csv("data/raw/Dataset/ATLANTIC-PR_Occurrence.csv", sep = ";")

  # Small mammals
  sites <- read.csv("data/raw/Mammals_UPRB_study_sites.csv")
  sp <- readr::read_csv("data/raw/Mammals_UPRB_species.csv")
  sp <- tidyr::pivot_longer(sp, dplyr::contains("ite_"), names_to = "site", values_to = "abundance", names_prefix = "site_")
  sp <- sp[sp$abundance != 0,]
  mamsmall2_dp <- dplyr::inner_join(sites, sp, by = "site")

  rm(sites,sp)


  ## Birds
  birds_dp <- read.csv("data/raw/DataS1/DataS1/ATLANTIC_BIRDS_qualitative.csv")

  ## iDigBio
  download.file("http://s.idigbio.org/idigbio-downloads/48532368-4e8e-4166-90f9-a4ee28002a4b.zip", "data/raw/idigbio.zip")
  unzip("data/raw/idigbio.zip", exdir = "data/raw")
  idigbio <- read.csv("data/raw/occurrence_raw.csv")

save(gbif, amp_dp, bat_dp, mamsmall_dp, mamct_dp, mamprim_dp, mamsmall2_dp, birds_dp, idigbio file = "data/raw/data.Rdata")
}
