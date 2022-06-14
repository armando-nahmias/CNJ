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

# Checando se o arquivo com os dados do MPM existe
if (file.exists('dados/dados_unidades.csv')) {
  # carregando arquivo com os dados anteriormente obtidos
  dados_unidades <- read.csv2('dados/dados_unidades.csv')
} else {
  # criando dataframe para os dados do mpm
  dados_unidades <- data.frame(
    data = character(),
    tipo_unidade = numeric(),
    classificacao_unidade = character(),
    telefone = numeric(),
    endereco = character(),
    email = character(),
    codigo_unidade = integer(),
    latitude = numeric(),
    longitude = numeric()
  )
}


### 
# Raspando os dados do Atena
###


# Definindo as url a serem consultadas
url_tcl_2022 <- paste(dominio, '/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=tcl', sep = '')
url_cp_2022 <- paste(dominio, '/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=cp', sep = '')
url_tpcp_2022 <- paste(dominio, '/indicadores/indicadores/tempo.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bjurisdicao_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=tpcp&qr%5Bcodigo_serventia_eq%5D=', sep = '')
url_sus_2022 <- paste(dominio, '/indicadores/indicadores.json?button=&page=1&per_page=30&q%5Banexo_eq%5D=&q%5Bano_eq%5D=2022&q%5Bgrupo_id_eq%5D=&q%5Bjurisdicao_eq%5D=&q%5Bs%5D=&q%5Btipo_eq%5D=&q%5Bvariavel_i_cont%5D=sus', sep = '')
url_tbaix_2022 <- paste(dominio, '/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=tbaix', sep = '')
url_iad_2022 <- paste(dominio, '/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=iad', sep = '')
url_cn_2022 <- paste(dominio, '/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=cn', sep = '')
url_serventias <- paste(dominio, '/indicadores/serventias.json', sep = '')
url_painel_litigiosidade <- paste(dominio, '/indicadores/dashboards/litigiosidade.json?button=&per_page=30&q%5Bano_eq%5D=2022&qr%5Bcodigo_serventia_eq%5D=67980&qr%5Bgrau_eq%5D=', sep = '')

# buscando variáveis do Atena
tcl_atena <- jsonlite::fromJSON(url_tcl_2022)
cp_atena <- jsonlite::fromJSON(url_cp_2022)
tpcp_atena <- jsonlite::fromJSON(url_tpcp_2022)
sus_atena <- jsonlite::fromJSON(url_sus_2022)
tbaix_atena <- jsonlite::fromJSON(url_tbaix_2022)
iad_atena <- jsonlite::fromJSON(url_iad_2022)
cn_atena <- jsonlite::fromJSON(url_cn_2022)
serventias <- jsonlite::fromJSON(url_serventias)
painel_litigiosidade <- jsonlite::fromJSON(url_painel_litigiosidade)



# IAD
# buscar iad por unidade, inclusive no 2 grau

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

