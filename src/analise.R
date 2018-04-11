##
# carregando dados...
##
vetDataFileName <- "data/dados_zootecnicos_e_ambientais.csv";
vet_dados <- read.csv2(file = vetDataFileName, stringsAsFactors = FALSE, fileEncoding = 'UTF-8')

#dim(vet_dados)
#str(vet_dados)


#table(vet_dados$IDADE)

vet_dados %>%
  ggplot(aes(x = TEMPERATURA_MEDIA, y = RACA, col = RACA)) + 
  geom_jitter(show.legend = T) +
  facet_grid(SEXO~MUNICIPIO, scale="free") +
  theme_bw() +
  labs(title = "Temperatura média dos animais por raça",
       x = "Tempreratura média Cº",
       y = "Raça") +
  theme(axis.line.x = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 90, hjust = 1))


dir.create('output/', showWarnings = FALSE)
png(filename = 'output/por_sexo.png', width = 8, height = 4, units = 'in', res = 300)
vet_dados %>%
  group_by(SEXO) %>%
  summarise(QTDE = n()) %>%
  ggplot(aes(x = SEXO, y = QTDE, fill = SEXO)) + 
  geom_bar(stat = "identity", position = "dodge", show.legend = F) +
  geom_text(aes(label = QTDE), fontface = "bold", show.legend = F,
          vjust = -0.3, size = 3) +
  theme_bw() +
  labs(title = "Quantitativo de animais por região e sexo",
       x = "Municipios",
       y = "Quantidade de animais") +
  theme(axis.line.x = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 25, hjust = 1))
dev.off()


png(filename = 'output/por_sexo_municipio.png', width = 8, height = 4, units = 'in', res = 300)
vet_dados %>%
  group_by(MUNICIPIO, SEXO) %>%
  summarise(QTDE = n()) %>%
  ggplot(aes(x = MUNICIPIO, y = QTDE, fill = SEXO)) + 
  geom_bar(stat = "identity", position = "dodge", show.legend = F)+
  geom_text(aes(label = QTDE), fontface = "bold", show.legend = F,
          vjust = -0.3, size = 3) +

  facet_grid(~SEXO, scale="free") +
  theme_bw() +
  labs(title = "Quantitativo de animais por região e sexo",
       x = "Municipios",
       y = "Quantidade de animais") +
  theme(axis.line.x = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 25, hjust = 1))
dev.off()


png(filename = 'output/por_sexo_raca.png', width = 8, height = 4, units = 'in', res = 300)
vet_dados %>%
  group_by(RACA, SEXO) %>%
  summarise(QTDE = n()) %>%
  ggplot(aes(x = RACA, y = QTDE, fill = SEXO)) + 
  geom_bar(stat = "identity", position = "dodge", show.legend = F)+
  geom_text(aes(label = QTDE), fontface = "bold", show.legend = F,
            vjust = -0.3, size = 3) +
  
  facet_grid(~SEXO, scale="free") +
  theme_bw() +
  labs(title = "Quantitativo de animais por raça e sexo",
       x = "Raças",
       y = "Quantidade de animais") +
  theme(axis.line.x = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 25, hjust = 1))
dev.off()


png(filename = 'output/por_sexo_idade.png', width = 8, height = 4, units = 'in', res = 300)
vet_dados %>%
  group_by(IDADE.CLASSIFICADA, SEXO) %>%
  summarise(QTDE = n()) %>%
  ggplot(aes(x = IDADE.CLASSIFICADA, y = QTDE, fill = SEXO)) + 
  geom_bar(stat = "identity", position = "dodge", show.legend = F)+
  geom_text(aes(label = QTDE), fontface = "bold", show.legend = F,
            vjust = -0.3, size = 3) +
  
  facet_grid(~SEXO, scale="free") +
  theme_bw() +
  labs(title = "Quantitativo de animais por faixa de idade e sexo",
       x = "Faixas de idade",
       y = "Quantidade de animais") +
  theme(axis.line.x = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 25, hjust = 1))
dev.off()


png(filename = 'output/por_sexo_finalidade.png', width = 8, height = 4, units = 'in', res = 300)
vet_dados %>%
  group_by(FIN_CRIACAO, SEXO) %>%
  summarise(QTDE = n()) %>%
  ggplot(aes(x = FIN_CRIACAO, y = QTDE, fill = SEXO)) + 
  geom_bar(stat = "identity", position = "dodge", show.legend = F)+
  geom_text(aes(label = QTDE), fontface = "bold", show.legend = F,
            vjust = -0.3, size = 3) +
  
  facet_grid(~SEXO, scale="free") +
  theme_bw() +
  labs(title = "Quantitativo de animais por finalidade de criação e sexo",
       x = "Finalidades de criação",
       y = "Quantidade de animais") +
  theme(axis.line.x = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 25, hjust = 1))
dev.off()





## Estratificando da população

estratos <- vet_dados %>%
  group_by(MUNICIPIO, REGIAO, SEXO, IDADE.CLASSIFICADA, RACA) %>%
  summarise(QTDE = n()) %>%
  ungroup() %>%
  arrange(desc(QTDE))

# calculando proporção dos estratos
estrato_total <- sum(estratos$QTDE)
estratos[,'perc'] <- ((estratos$QTDE * 100) / estrato_total) * 7 # exedendo em 700% para tornar a proporcionalidade significativa devido ao grande numero de estratos

# caldulando numero de individuos proporcionais em cada estrato
estratos[,'n_individuos'] <- ceiling(estratos$QTDE * ( ceiling(estratos$perc) / 100))
# sum(estratos$n_individuos)

# verificar se o numero de individuos a serem sorteados, são selecionáveis dentro do estrato
any(estratos$QTDE < estratos$n_individuos) 

# formando os estratos e sorteando os n elementos dentro dos respectivos estratos
amostraGlobal <- c()
set.seed(21)
for (i in 1:nrow(estratos)) {
  currEstrato <- estratos[i,]
  
  # selecionando o estrato
  grupoEstratificado <- vet_dados %>%
                          filter(MUNICIPIO == currEstrato$MUNICIPIO, REGIAO == currEstrato$REGIAO, SEXO == currEstrato$SEXO, 
                                 IDADE.CLASSIFICADA == currEstrato$IDADE.CLASSIFICADA, RACA == currEstrato$RACA)
  
  # sorteando os n elementos no estrato
  amostraDoEstrato <- sample(x = grupoEstratificado$ANIMAL, currEstrato$n_individuos)
  
  # inserindo os elementos na amostra geral
  amostraGlobal <- c(amostraGlobal, amostraDoEstrato)
  
  #message(paste0('# ', i, ' - Tam do estrato ', nrow(grupoEstratificado), ', tam esperado ', currEstrato$n_individuos))

  # message(paste0('Estrato (', nrow(grupoEstratificado) ,'):'))
  # print(grupoEstratificado$ANIMAL)
  # message(paste0('Selecionados (', currEstrato$n_individuos ,'):'))
  # print(amostraDoEstrato)
  # message('\n')
  
}

# vet_dados[amostraGlobal,1] %>% head

# salvando a amostra extratificada
write.csv2(x = vet_dados[amostraGlobal,], file = "data/amostra_extratificada.csv", fileEncoding = "UTF-8", row.names = FALSE)
