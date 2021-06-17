---
title: "Mapping and understanding the digital biodiversity knowledge about vertebrates in the Atlantic Rainforest"

author:
- Gracielle T. Higino^1^, ^2^ \*, Pablo Henrique da Silva^3^, Marcos V. C. Vital^4^
- ^1^ Department of Zoology and Biodiversity Research Centre, University of British Columbia, Vancouver, BC, Canada.
- ^2^ Programme de formation en sciences et services de la biodiversité computationnelle, Canada.
- ^3^ Instituto de Matemática e Estatística, Universidade Federal de Goiás, Goiânia, Brazil.
- ^4^ Instituto de Ciências Biológicas e da Saúde, Universidade Federal de Alagoas, Maceió, AL, Brazil
- <br/>
- \*Corresponding author
- \***graciellehigino@gmail.com**



knit: (function(inputFile, encoding) {
      out_dir <- 'manuscript';
      rmarkdown::render(inputFile,
                        encoding = encoding,
                        output_file = file.path(dirname(inputFile),
                        out_dir,
                        'manuscript.docx')) })
output:
  word_document:
    reference_docx: sources/template.docx
csl: sources/ecology-letters.csl
bibliography:
- sources/library.bib
- sources/installed-r-packages.bib
---

# Abstract

Biases and gaps in biodiversity data can have serious consequences for ecological
and conservation research and actions, as it can lead to incorrect conclusions.
Although there is still digital knowledge to be found and organized, recent
efforts on gathering global biodiversity data, such as data papers, have
revealed long hidden information. Nevertheless, it is of major importance to map
and describe the biases on the data we have available. Here we assessed
terrestrial vertebrates' digital inventory incompleteness at the Atlantic
Rainforest and investigated if environmental variables are correlated to
biodiversity knowledge. At a resolution of 0.5 degrees and considering the final
slope of a rarefaction curve as a measure of inventory completeness, none of the
grids can be considered well sampled units. However, the completeness of each
group seems to have a non-uniform correlation to different environmental
variables. By highlighting undersampled areas in the Atlantic Rainforest, these
results provide important information for the biodiversity assessment of this
highly disturbed ecoregion. Combining them with the information about the
magnitude of these impacts can help shape the agenda and priorities for
conservation, but, also, the results alone can help us rethink what we
understand about geographically structured biodiversity distribution.  
Keywords: inventory completeness, rarefaction curves, data bias, Atlantic Rainforest.

\newpage

# Introduction

Information about life diversity and distribution is a fundamental tool for
understanding evolutionary and ecological processes [@Graham2004NewDev;
@Jetz2012IntBio; @Rocchini2011AccUnc; @Ladle2013MapSpe; @Meyer2015GloPri]. After
a long history of biodiversity information collection by naturalists,
taxonomists and, more recently, citizen scientists [@VonHumboldt1850VieNat;
@Hawkins2001EcoSO; @Willig2003LatGra; @Chase2012HisCon; @Callaghan2020CitSci],
researchers have been storing these data in electronic cataloges at slow pace
since the 1970’s, connecting them, more recently, through web-based initiatives
[@Graham2004NewDev]. As a result, we now have accessible and extensive
information about biodiversity on big online databases such as the Global
Biodiversity Information Facility (GBIF; http://www.gbif.org/) and the Map of
Life (https://mol.org/), which compile museum, survey and observation data
[@Graham2004NewDev; @Jetz2012IntBio; @Beck2013OnlSol]. However, despite these
recent efforts, our knowledge on species diversity and distribution is still
biased and full of gaps due to the complex nature of this information
[@Brown1998Bio; @Whittaker2005ConBio]. Different aspects of shortfalls related
to this knowledge have been recently revised [@Hortal2015SevSho] and there is
growing evidence that they can compromise ecological, evolutionary and
conservation analyses [@IUCN2012IucRed; @Ladle2013MapSpe; @Ficetola2014SamBia;
@Hortal2015SevSho].  

The Wallacean shortfall (the lack of information about species’ real
distribution) is present in every spatial and temporal scales
[@Whittaker2005ConBio; @Hortal2008UncMea; @Hortal2015SevSho] and is a
consequence of a myriad of biological, environmental and social factors.
Characteristics of the species (such as crypsis, its natural history and
behaviour), political borders and topography, for example, can lead to biases in
biodiversity surveys and form gaps in information. On the other hand, clustered
information also can lead to biased surveys, since researchers may prefer to
assess places knowingly species-rich or that are undergoing a process of
ecological change [@Boakes2010DisVie; @Ahrends2011FunBeg; @Rocchini2011AccUnc;
@Yang2014EnvSoc]. Information gaps may also be a consequence of data quality
decay in space (e.g., when we extrapolate the distribution of a species based on
polygons or species distribution models) and time (due to taxonomic reviews,
climate change, land use, habitat loss, extinction and migration)
[@Ladle2013MapSpe; @Tessarolo2017TemDeg]. Therefore, the measurement of
geographical variation of biodiversity on the planet (represented by
distribution maps) has an error associated that must be assessed
[@Hortal2008UncMea; @Rocchini2011AccUnc; @Ladle2013MapSpe; @Yang2013GeoSam].   

The underestimation of species distribution can have consequences in
conservation planning, such as the classification of species in risk of
extinction following the range restriction criterion [@IUCN2012IucRed;
@Ladle2013MapSpe; @Ficetola2014SamBia; @Hortal2015SevSho]. Furthermore, bias can
influence and even reverse ecogeographical patterns, leading us to associate
certain factors to species richness when they are only proxies for sampling
quality [@Ficetola2014SamBia]. These are examples of why the acknowledgment of
error in biodiversity information is of major importance. For that reason, it
has been recommended to include maps of ignorance in the results or to map data
quality and use only well sampled locations on analyses [@Hortal2008UncMea;
@Ladle2013MapSpe; @Ficetola2014SamBia; @Yang2014EnvSoc]. These maps could help
detecting biasing variables, and the researcher could therefore chose the most
apropriate procedure to deal with them - by removing them or adding weights,
for example [@Boakes2010DisVie; @Stockwell2002ConBia] -, in order to perform
better analyses, but they are only possible once researchers are aware of the
error in their data sets. This practice, in addition to guide future research,
produces more reliable results, since the exact measure of uncertainty clarifies
how explicative an inference can be.  

There is a growing interest in biodiversity data biases in the literature (see
Boakes *et al*. [-@Boakes2010DisVie]; Yang *et al*. [-@Yang2013GeoSam];
Sousa-Baena *et al*. [-@Sousa-Baena2014ComDig]). Nevertheless, studies mapping
South American under-sampled sites are relatively few. This is worrying
especially for the Atlantic Forest because this ecoregion is an important
biodiversity and socio-climatic hotspot [@Scarano2015BraAtl]. Human activities
and the growth of urban centres have significantly reduced its original, and
estimations suggest the remaining native vegetation area to be of only 28%
[@Rezende2018HotHop], while others suggest it could be as little as 8%
[@Galindo-Leal2003AtlFor; @Scarano2015BraAtl], resulting in substantial loss of
habitat. Despite that, it still hosts 1-8% of the world’s total species
[@Silva2003StaBio]. The Atlantic Rainforest is also a good model for ecological
and evolutionary research because of its large latitudinal and altitudinal
range, high endemicity, variation in temperature and precipitation, and
historical connexion with other biomes [@Silva2003StaBio; @Ribeiro2009BraAtl;
@Batalha-Filho2013ConAtl]. Given that the Atlantic Rainforest is a highly
impacted biodiversity hotspot, it becomes urgent to describe and map the
information about species occurrence in this ecoregion that is available online.

Here we aim to map and quantify the gaps on digital occurrence data of
terrestrial vertebrates available on GBIF, Integrated Digitized Biocollections
(iDigBio; www.idigbio.org) and those published by the ATLANTIC project data
papers [@Bovendorp2017AtlSma; @Lima2017AtlDat; @Muylaert2017AtlBat;
@Goncalves2018NonMam; @Hasui2018AtlBir; @Vancine2018AtlAmp; @Culot2019AtlDat;
@Souza2019AtlMam]. Although there is valuable and important data stored on other
data repositories such as Dryad and Zenodo, they do not follow a standard
structure, and very often miss quality metadata [@Rousidis2014MetBig], which
often makes their use in macroecological research more challenging. Moreover,
the most frequent use of the GBIF data is in species distribution research
[@Heberling2021DatInt], given the large-resolution, integrated datasets design
[@Konig2019BioDat]. The GBIF database also encompasses other more specific and
local databases, such as eBird (a specialized database for birds;
@Sullivan2009EbiCit) and SiBBr, the Brazilian node of GBIF focused on local
occurrence records (Sistema de Informação sobre a Biodiversidade Brasileira,
www.sibbr.gov.br).

As a further investigation, we try to identify environmental variables that may
be related to these shortfalls. As beforementioned, the Wallacean shortfall can
be the result of many factors, including environmental Because of the extensive
use of large biodiversity databases to investigate species richness distribution
and its relationship with environmental gradients, we hypothesize that these
relationships could influence the amount of samples taken at each location.
Therefore we chose four environmental variables that are known to have positive
relationships with species richness at large scale (mean annual temperature -
characterizing warmer regions -, altitudinal range variation - characterizing
regions with high speciation probability - and potential evapotranspiration -
characterizing highly productive environments). Additionally, we investigated
weather the inventory completeness is related to distance to conservation units,
since preserved areas could be highly attractive to naturalists.

<!--- update after results >
We identify three main sources of biases on those data: environmental (well sampled units are
correlated to environmental variables), geographic (well sampled units are not
randomly distributed in space) and taxonomic (the inventory of some groups is
more complete than others).
<!--->

# Methods

### Data collection and cleaning
The inventory completeness of Atlantic Rainforest fauna was analysed for
amphibians, birds, mammals and reptiles. We used occurrence data from the Global
Biodiversity Information Facility, which was downloaded on March 16th 2021 by
classes’ names, using geometric filtering and excluding fossil records
[@GBIF.org2021GbiOcc]. We also used all datasets from the ATLANTIC project related to
these groups of vertebrates (complete list of data sources available in
Supplementary Table 1). Since not all databases had the same metadata, we
filtered occurrences based only on common variables, such as scientific name,
class and geographic coordinates.  

We checked scientific names for validity using the ‘taxize’ R package
[@Chamberlain2013TaxTax; @Chamberlain2014TaxTax], based on the National Center
for Biotechnology Information Taxonomy Database
(http://www.ncbi.nlm.nih.gov/taxonomy), Mammal Species of the World (3rd
edition, http://vertebrates.si.edu/msw/mswcfapp/msw/index.cfm) and The Reptile
Database (http://reptile-database.reptarium.cz/), BirdLife International
(https://www.birdlife.org/), Integrated Taxonomic Information System
(https://www.itis.gov/) and GBIF. We filtered the remaining occurrence points by
the Atlantic Rainforest domain *sensu* Olson *et al*. [-@Olson2001TerEco] (Fig. 01)
and then assessed species richness and number of occurrences by grid cells of 30
arc-minutes (~55km at Equator), which we used for calculating inventory
completeness. This resolution was chosen because it captures macroecological
trends while revealing important regional variations. It was not in the scope of
this study to investigate the inventory completeness and its relationship with
environmental variables at local scale, nor should we use coarser resolutions
given the limited extension of the study area.
<!---TODO #9>
Create Supplementary Table 1 with all data sources: https://docs.google.com/spreadsheets/d/1qq6YTTcAIZVI9olRVgSm5sKVlxuS-4yW-yD06TXJzgg/edit?usp=sharing
<!--->

### Inventory completeness
Two approaches were used to evaluate inventory completeness in the Atlantic
Forest: the species accumulation curve for the whole region followed by the
analysis of its final 10% slope [@Yang2013GeoSam], and a rarefaction method for
each sampling unit (SU), also assessing the sample slope. The species
accumulation curve is a sample-based method for assessing sampling effort and
estimate species richness [@Colwell1994EstTer; @Gotelli2001QuaBio]. This
approach was performed with the method ‘exact’ of the function‘specaccum’ and
the final 10% slopes were extracted with function ‘specslope’ in the R package
‘vegan’ [@Oksanen2015VegCom]. The output of this function was analysed according
to Yang *et al*. [-@Yang2013GeoSam] and slopes higher than 0.05 were considered
as indicators of inventory incompleteness. The rarefaction curve is an
individual-based method that represents the sampling effort needed to reach
total estimated richness within an area [@Gotelli2001QuaBio].
<!--->review the definition of rarrefaction curve and explicit what was used as samples in both
rarefy and rareslope functions<--->The ‘rarefy’ and ‘rareslope’ functions in R
calculate the rarefaction and slopes of each SU, both operating in the same
package abovementioned.

### Geographic analyses
Additionally, we investigated if four environmental variables were correlated
with inventory completeness. These variables were chosen based on previous
studies indicating their influence on data bias or if they are commonly
mentioned as proxies for species richness [@Currie1991EneLar;
@Sanchez-Fernandez2008BiaFre; @Toranza2010CroCon; @Martin2012MapWhe;
@Ficetola2014SamBia; @Vasconcelos2014BioDis; @Yang2014EnvSoc]. We used annual
mean temperature and altitudinal range downloaded from WorldClim (resolution
30"), through the package `raster` [@Hijmans2016RasGeo] and potential
evapotranspiration (PET) data from the Consortium for Spatial Information  of
the Consultative Group for International Agricultural Research (resolution 30")
[@Trabucco2009GloPot]. Temperature and PET represent ecosystems’ energy income,
while altitudinal range represents topographical and, therefore, habitat
homogeneity. All variables were also rescaled to 30 arc-seconds resolution
grids.
<!--TODO confirm resolution>
<-->

TODO #11
Análise descritiva das variáveis ambientais e rodar um stepwise regression para
selecionar as variáveis que entram no modelo. Entender para cada grupo quais
variáveis que são mais interessantes para o gwr.

We did a Geographically Weighted Regression (GWR) [@Brunsdon1998GeoWei], that
considers the spatial structure of the data, to investigate if these
correlations are consistent through space. This analysis was made with the
‘spgwr’ package [@Bivand2017SpgGeo]. Finally, we assessed taxonomic bias by investigating
collinearity through a Principal Component Analysis (PCA) of all the slopes,
using the ‘prcomp’ function of the package ‘vegan’. Statistical analyses were
performed using the computing environment R 3.5.1 [@RCoreTeam2018RLan].

# References