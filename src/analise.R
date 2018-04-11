##
# carregando dados...
##
vetDataFileName <- "data/dados_zootecnicos_e_ambientais.csv";
vet_dados <- read.csv2(file = vetDataFileName, stringsAsFactors = FALSE, fileEncoding = 'UTF-8')

#dim(vet_dados)
#str(vet_dados)


#table(vet_dados$IDADE)

vet_dados %>%
  ggplot(aes(x = Temperatura_media, y = RACA, col = RACA)) + 
  geom_jitter(show.legend = T) +
  facet_grid(SEXO~MUNICIPIO, scale="free") +
  theme_bw() +
  labs(title = "Temperatura média dos animais por raça",
       x = "Tempreratura média Cº",
       y = "Raça") +
  theme(axis.line.x = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 90, hjust = 1))



vet_dados %>%
  group_by(MUNICIPIO, SEXO) %>%
  summarise(QTDE = n()) %>%
  ggplot(aes(x = MUNICIPIO, y = QTDE, fill = SEXO)) + 
  geom_bar(stat = "identity", position = "dodge", show.legend = F)+
  geom_text(aes(label = QTDE), fontface = "bold", show.legend = F,
          vjust = -0.8, size = 5) +

  facet_grid(~SEXO, scale="free") +
  theme_bw() +
  labs(title = "Distribuição dos animais por região e sexo",
       x = "Tempreratura média Cº",
       y = "Raça") +
  theme(axis.line.x = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 25, hjust = 1))
