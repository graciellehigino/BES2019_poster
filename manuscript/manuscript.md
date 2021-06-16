---
title: "Mapping and understanding the digital biodiversity knowledge about vertebrates in the Atlantic Rainforest"

author:
- Gracielle T. Higino^1^, ^2^ \*, Pablo Henrique da Silva^3^, Marcos V. C. Vital^4^
- ^1^ Department of Zoology and Biodiversity Research Centre, University of British Columbia, Vancouver, BC, Canada.
- ^2^ Programme de formation en sciences et services de la biodiversité computationnelle, Canada.
- ^3^ Instituto de Matemática e Estatística, Universidade Federal de Goiás, Goiânia, Brazil.
- ^4^ Instituto de Ciências Biológicas e da Saúde, Universidade Federal de Alagoas, Maceió, AL, Brazil
- <br/>
- <br/>
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

# Introduction

Information about life diversity and distribution is a fundamental tool for
understanding evolutionary and ecological processes [@Graham2004NewDev;
@Jetz2012IntBio; @Rocchini2011AccUnc; @Ladle2013MapSpe; @Meyer2015GloPri]. After
a long history of biodiversity information collection by naturalists,
taxonomists and, more recently, citizen scientists [@VonHumboldt1850VieNat;
@Hawkins2001EcoSO; @Willig2003LatGra; @Chase2012HisCon; @Callaghan2020CitSci],
researchers have been storing these data in electronic catalogues at slow pace
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

The wallacean shortfall (the lack of information about species’ real
distribution) is present in every spatial and temporal scales
[@@Whittaker2005ConBio; @Hortal2008UncMea; @Hortal2015SevSho] and is a
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
quality [@Ficetola2014SamBia]. These are examples of why the acknowledgement of
error in biodiversity information is of major importance. For that reason, it
has been recommended to include maps of ignorance in the results or to map data
quality and use only well sampled locations on analyses [@Hortal2008UncMea;
@Ladle2013MapSpe; @Ficetola2014SamBia; @Yang2014EnvSoc]. These maps could help
detecting biasing variables, and the researcher could therefore chose the most
apropriate procedure to deal with them - by removing them or adding wheights,
for example [@Boakes2010DisVie; @Stockwell2002ConBia] -, in order to perform
better analyses, but they are only possible once researchers are aware of the
error in their data sets. This practice, in addition to guide future research,
produces more reliable results, since the exact measure of uncertainty clarifies
how explicative an inference can be.  

There is a growing interest in biodiversity data biases in the literature (see
Boakes *et al*. -[@Boakes2010DisVie]; Yang *et al*. -[@Yang2013GeoSam];
Sousa-Baena *et al*. -[@Sousa-Baena2014ComDig]). Nevertheless, studies mapping
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
historical connexion with other biomes [@Silva2003StaBio; @Ribeiro2009BraAtlb;
@Batalha-Filho2013ConAtl]. Given that the Atlantic Rainforest is a highly
impacted biodiversity hotspot, it becomes urgent to describe and map the
information about species occurrence in this ecoregion that is available online.


# References