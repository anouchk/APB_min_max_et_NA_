library(data.table)

#lire apb
apb=fread('/Users/analutzky/Desktop/fr-esr-apb_voeux-et-admissions.csv')
setwd('~/Desktop/apb_prepas_boursiers_2016_2017/')


### regarder l'objet
# afficher les premières et dernières ligne de apb (pour des objets de type data.table)
apb
# afficher les noms de colonnes
colnames(apb)
# dans R studio (pour des tableaux pas trop grands) 
View(apb)
# -> affichage excel-like


### supprimer les espaces et caractères spéciaux des noms de colonnes
colnames(apb)=make.names(colnames(apb))

# afficher les nouveaux noms de colonnes
colnames(apb)


### Convertir les variables qui nous intéressent en numérique 
# R renvoie un warning parce que certaines valeurs sont a 'inconnu' ou '', et il ne peut pas les convertir en nombre. 
# Il met des NA, et ça nous convient très bien.
apb=apb[,Effectif.total.des.candidats.admis:=as.numeric(Effectif.total.des.candidats.admis)]
apb=apb[,Effectif.des.admis.boursiers:=as.numeric(Effectif.des.admis.boursiers)]
apb=apb[,Demandes.en.vœu.1:=as.numeric(Demandes.en.vœu.1)]

# au passage on donne un nom plus joli a la variable pourcentage
apb=apb[,Pct.admis.boursiers:=as.numeric(X..admis.boursiers)] 


### calculer les moyennes par session
apb_moyenne_par_Sessions=apb[,.(Effectif.total.des.candidats.admis=sum(Effectif.total.des.candidats.admis,na.rm=T),
		Effectif.des.admis.boursiers=sum(Effectif.des.admis.boursiers,na.rm=T),
		Demandes.en.vœu.1=sum(Demandes.en.vœu.1,na.rm=T))
		,by=Session]

### ici, noter les na.rm=T qui signifient retirer les NA quand on calcule la somme ou la moyenne.
# si on ne met pas ça, R renvoie des NA partout. 
# Pour R la somme d'un chiffre et d'un NA, c'est NA par défaut.
# Si on veut la somme là ou les données sont disponibles, il faut mettre na.rm=T

### calculer le pourcentage global des admis qui sont boursier
apb_moyenne_par_Sessions[,Pct.global.admis.boursier:=Effectif.des.admis.boursiers/Effectif.total.des.candidats.admis*100]
# note: 
# Pct.moyen.admis.boursier donne la moyenne sur tous les établissement du pourcentage calculé dans chaque établissement.
# Pct.global.admis.boursier donne le total des admis boursier divisé par le total des admis. 
# Ici c'est très proche, mais c'est pas tout à fait la même chose, d'ou un très léger écart.

#Et on affiche les résultats
apb_moyenne_par_Sessions

apb_moyenne_par_académie_Prepa=apb[Session==2017 & Filières.très.agrégées=='4_CPGE' & Effectif.total.des.candidats.admis>0,.(Effectif.total.des.candidats.admis=sum(Effectif.total.des.candidats.admis,na.rm=T),
		Effectif.des.admis.boursiers=sum(Effectif.des.admis.boursiers,na.rm=T))
		,by=Académies]
apb_moyenne_par_académie_Prepa[,Pct.global.admis.boursier:=Effectif.des.admis.boursiers/Effectif.total.des.candidats.admis*100]

apb_moyenne_par_Etablissement_Prepa=apb[Session==2017 & Filières.très.agrégées=='4_CPGE' & Effectif.total.des.candidats.admis>0,.(Effectif.total.des.candidats.admis=sum(Effectif.total.des.candidats.admis,na.rm=T),
		Effectif.des.admis.boursiers=sum(Effectif.des.admis.boursiers,na.rm=T))
		,by=.(Code.UAI.de.l.établissement.d.accueil,Libellé.de.l.établissement.d.accueil,Académies)]
apb_moyenne_par_Etablissement_Prepa[,Pct.global.admis.boursier:=Effectif.des.admis.boursiers/Effectif.total.des.candidats.admis*100]

apb_moyenne_par_Etablissement_Prepa_annot=merge(apb_moyenne_par_Etablissement_Prepa,apb_moyenne_par_académie_Prepa,by='Académies',suffixes=c('_etab','_acad'),all=T)

apb_minBoursier_par_acad_Prepa=apb_moyenne_par_Etablissement_Prepa[order(Pct.global.admis.boursier),.SD[1],by=Académies]
apb_maxBoursier_par_acad_Prepa=apb_moyenne_par_Etablissement_Prepa[order(Pct.global.admis.boursier),.SD[.N],by=Académies]


write.csv2(apb_minBoursier_par_acad_Prepa,file='apb_minBoursier_par_acad_Prepa.csv')
write.csv2(apb_maxBoursier_par_acad_Prepa,file='apb_maxBoursier_par_acad_Prepa.csv')
