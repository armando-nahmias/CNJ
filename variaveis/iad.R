### 
# Preparando o ambiente
###

# Definindo o dominio para acesso ao Atena
#dominio <- readline(prompt = 'Informe o endereço para acessar o atena no caso do TRE/RR, o endereço é http://atena.tre-rr.jus.br:')
dominio <- 'http://atena.tre-rr.jus.br'


# Especificando os pacotes necessários para o roteiro
pacotes <- c("jsonlite", "comprehenr", "tibble", 'curl')
# Verificando os pacotes não instalados
nao_instalados <- pacotes[!(pacotes %in% installed.packages()[ , "Package"])]
# Instalando os pacotes faltantes
if(length(nao_instalados)) install.packages(nao_instalados)

# carregando os pacotes necessários para o roteiro
library("jsonlite", 'comprehenr', 'tibble')

# Checando se a pasta de dados existe
if (!file.exists('dados')) {
  # Criando a pasta de dados para receber os arquivos csv
  dir.create('dados')
}

# Checando se o arquivo com os dados das serventias existe
if (file.exists('dados/dados_serventias.csv')) {
  # carregando arquivo com as variáveis anteriormente calculadas
  dados_serventias <- read.csv2('dados/dados_serventias.csv')
}

### 
# Raspando os dados do Atena
###


# Definindo as url a serem consultadas
url_serventias <- paste(dominio, '/indicadores/serventias.json', sep = '')
url_painel_litigiosidade <- paste(dominio, '/indicadores/dashboards/litigiosidade.json?button=&per_page=30&q%5Bano_eq%5D=2022&qr%5Bcodigo_serventia_eq%5D=67980&qr%5Bgrau_eq%5D=', sep = '')

# buscando variáveis do Atena
serventias <- jsonlite::fromJSON(url_serventias)
painel_litigiosidade <- jsonlite::fromJSON(url_painel_litigiosidade)



# IAD
# buscar iad por unidade, inclusive no 2 grau

painel_litigiosidade$variaveis$valor_anual[12]
painel_litigiosidade$url


# verificando o arquivo com os dados foi carregado
if (!exists('dados_serventias')) {
  # criando base de dados das serventias
  dados_serventias <- data.frame(
    codigo_serventia = serventias$codigo_serventia,
    descricao_serventia = serventias$descricao
  )
}

# iterando em cada serventia
for (serventia in serventias$codigo_serventia) {
  
  #construindo a url para raspar o atena
  dominio <- 'http://atena.tre-rr.jus.br'
  indicador <- '/indicadores/dashboards/litigiosidade.json?button=&per_page=30&q%5Bano_eq%5D=2022&qr%5Bcodigo_serventia_eq%5D='
  variavel <- '&qr%5Bgrau_eq%5D='
  
  url_painel_litigiosidade <- sprintf('%s%s%s%s', dominio, indicador, serventia, variavel)
  
  painel <- jsonlite::fromJSON(url_painel_litigiosidade)
  
  
  # obtendo o iad da 1 instancia
  dados_serventias$iad1[dados_serventias$codigo_serventia == serventia] <- painel$variaveis$valor_anual[12]
  
  # obtendo o iad da 2 instancia
  dados_serventias$iad2[dados_serventias$codigo_serventia == serventia] <- painel$variaveis$valor_anual[6]
  
  # buscar unidades do juizo digital
  dados_serventias$juizo_digital[dados_serventias$codigo_serventia == serventia] <- serventias$juizo_digital[serventias$codigo_serventia == serventia]
  
  # geolocalizar unidades judiciarias
  dados_serventias$longitude[dados_serventias$codigo_serventia == serventia] <- serventias$longitude[serventias$codigo_serventia == serventia]
  dados_serventias$latitude[dados_serventias$codigo_serventia == serventia] <- serventias$latitude[serventias$codigo_serventia == serventia]
  
}

### 
# Calculando os valores
###

# Calculando o IAD
iad_calculado <- (tbaix1+tbaix2)/(cn1+cn2)

# Verificando data da consulta
data <- Sys.time()
data <- as.character(data)

### 
# Guardando as variáveis obtidas
###


# guardando os dados no arquivo de variaveis
write.csv2(dados_serventias, 'dados/dados_serventias.csv', row.names = FALSE)

