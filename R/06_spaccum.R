occ <- bind_rows("amp" = amp[1:3], "rep" = rep[1:3], .id="class")

# Slope of the species accumulation curve
occ$abundance<-1
occ$abundance<-as.integer(occ$abundance)
occ$cells <- cells
tt<-sqldf("select cells, count(species) as N_rec from occ group by cells having count(species) > 0")
df<-merge(x=occ, y=tt, by="cells", all.y=TRUE)
df<-df[, c(1, 4, 6)]
mat<-spaa::data2mat(df)

# From Stropp et al.:
spaccum <- specaccum(mat, method = "exact")
total.slope <- (spaccum[[4]][length(spaccum[[4]])]-spaccum[[4]][ceiling(length(spaccum[[4]])*0.9)])/(length(spaccum[[4]])-ceiling(length(spaccum[[4]])*0.9))

save(spaccum, total.slope, file="output/results/total_accum.Rdata")

plot(spaccum,add=FALSE,random=FALSE,ci=2,ci.type="polygon",col=par("fg"),ci.col="grey",xlim=c(1,170),
ci.lty=1,ylab="exact",xvar="sites")
text(round(total.slope,digits=3), x=160, y=50,pos=3)
text("Slope = ", x=143, y=50,pos=3)

# Species richness by cell
sr<-sqldf("select cells, count (distinct(species)) as sr_total from occ group by cells")


## Rarefaction analyses
# New dataset
tot<-merge(tt,sr, by="cells", all=TRUE)
# Expected total richness
exp.sr<-rarefy(tot$sr_total,tot$N_rec)
exp.sr<-as.list(exp.sr)
# Slope of the rarecurve for each cell
slope.sr<-rareslope(tot$sr_total,tot$N_rec)
