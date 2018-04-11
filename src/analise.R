##
# carregando dados...
##
vetDataFileName <- "data/dados_zootecnicos_e_ambientais.csv";
vet_dados <- read.csv2(file = vetDataFileName, stringsAsFactors = FALSE, fileEncoding = 'UTF-8')

dim(vet_dados)
str(vet_dados)
