# Especificando os pacotes necessários para o roteiro
pacotes <- c("jsonlite", "comprehenr", "tibble", 'curl')
# Verificando os pacotes não instalados
nao_instalados <- pacotes[!(pacotes %in% installed.packages()[ , "Package"])]
# Instalando os pacotes faltantes
if(length(nao_instalados)) install.packages(nao_instalados)

# carregando os pacotes necessários para o roteiro
library("jsonlite", 'comprehenr', 'tibble')


# Checando se o arquivo com as variáveis existe
if (file.exists('dados/iad_unidades.csv')) {
  # carregando arquivo com as variáveis anteriormente calculadas
  iad_unidades <- read.csv2('dados/iad_unidades.csv')
} else {
  # criando dataframe para as variaveis
  iad_unidades <- data.frame(
    codigo_serventia = integer(),
    serventia_descricao = character(),
    nr_unico = character(),
    grau = numeric(),
    origem = character(),
    cod_classe_cnj = integer(),
    classe_sigla = character(),
    tpcp2 = integer(),
    data_autuacao = character(),
    data_ocorrencia = character(),
    tipo_decisao = character(),
    magistrado_nome = character()
  )
}



variaveis_2022 <- data.frame(
  TBaixCCrim1 = '704',
  TBaixCNCrim1 = '705',
  TBaixExtFisc1 = '706',
  TBaixCrim2 = '707',
  TBaixNCrim2 = '708',
  CnCCrim1 = '713',
  CnCNCrim1 = '714',
  CnExtFisc1 = '716',
  CnOCrim2 = '718',
  CnONCrim2 = '719',
  CnRCrim2 = '720',
  CnRNCrim2 = '721'
)

variaveis_2021 <- data.frame(
  TBaixCCrim1 = '40',
  TBaixCNCrim1 = '41',
  TBaixExtFisc1 = '42',
  TBaixCrim2 = '55',
  TBaixNCrim2 = '56',
  CnCCrim1 = '109',
  CnCNCrim1 = '110',
  CnExtFisc1 = '112',
  CnOCrim2 = '144',
  CnONCrim2 = '145',
  CnRCrim2 = '146',
  CnRNCrim2 = '147'
)


#construindo a url para raspar o atena
url_1 <- 'http://atena.tre-rr.jus.br/'
url_2 <- 'indicadores/indicadores/'
url_3 <- '.json'

# iterando em cada variavel
for (variavel in variaveis_2022[1:2]) {
  #construindo a url para raspar o atena
  
  url_indicador_mensal <- sprintf('%s%s%s%s', url_1, url_2, variavel, url_3)
  
  painel <- jsonlite::fromJSON(url_indicador_mensal)
  print(painel)
  

  for (serventia in painel$registros$codigo_serventia[1:2]) {
    print(painel$registros$codigo_serventia)
    print(painel$registros$serventia_descricao)
    print(painel$registros$nr_unico)
    # # montando base de dados
    # iad_unidades[nrow(iad_unidades) + 1,] <- data.frame(
    #   codigo_serventia = painel$registros$codigo_serventia,
    #   serventia_descricao = painel$registros$serventia_descricao,
    #   nr_unico = painel$registros$nr_unico,
    #   grau = painel$registros$grau,
    #   origem = painel$registros$origem,
    #   cod_classe_cnj = painel$registros$cod_classe_cnj,
    #   classe_sigla = painel$registros$classe_sigla,
    #   tpcp2 = painel$registros$tpcp2,
    #   data_autuacao = painel$registros$data_autuacao,
    #   data_ocorrencia = painel$registros$data_ocorrencia,
    #   tipo_decisao = painel$registros$tipo_decisao,
    #   magistrado_nome = painel$registros$magistrado_nome
    # )
    # 
  }
  
}

iad_unidades

# TBaixCrim2_2021 <- http://atena.tre-rr.jus.br/indicadores/indicadores/55.json

# TBaix1 <- TBaixCCrim1 + TBaixCNCrim1 + TBaixExtFisc1
# TBaix2 <- TBaixCrim2 + TBaixNCrim2
# 
# Cn2 <- CnOCrim2 + CnONCrim2 + CnRCrim2 + CnRNCrim2
# Cn1 <- CnCCrim1 + CnCNCrim1 + CnExtFisc1
# 
# iad1 <- (TBaix1) / (Cn1)
# iad2 <- (TBaix2) / (Cn2)
# 
# 
