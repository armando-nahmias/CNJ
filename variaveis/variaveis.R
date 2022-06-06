### 
# Preparando o ambiente
###

# Definindo o dominio para acesso ao Atena
#dominio <- readline(prompt = 'Informe o endereço para acessar o atena no caso do TRE/RR, o endereço é http://atena.tre-rr.jus.br:')
dominio <- 'http://atena.tre-rr.jus.br'


# Especificando os pacotes necessários para o roteiro
pacotes <- c("jsonlite", "comprehenr", "tibble")
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

# Checando se o arquivo com as variáveis existe
if (file.exists('dados/dados_serventias.csv')) {
  # carregando arquivo com as variáveis anteriormente calculadas
  iad_serventias <- read.csv2('dados/dados_serventias.csv')
}

# Checando se o arquivo com as variáveis existe
if (file.exists('dados/variaveis.csv')) {
  # carregando arquivo com as variáveis anteriormente calculadas
  variaveis <- read.csv2('dados/variaveis.csv')
} else {
  # criando dataframe para as variaveis
  variaveis <- data.frame(
    data = character(),
    tcl_calculada = numeric(),
    tcl1 = numeric(),
    tcl2 = numeric(),
    tpcpl_calculado = numeric(),
    tpcp1 = integer(),
    tpcp2 = integer(),
    iad_calculado = numeric(),
    iad1 = numeric(),
    iad2 = numeric(),
    cp1 = integer(),
    cp2 = integer(),
    sus1 = integer(),
    sus2 = integer(),
    tbaix1 = integer(),
    tbaix2 = integer(),
    cn1 = integer(),
    cn2 = integer()
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



#TCL
# buscando os valores já calculados da TCL
tcl2 <- tcl_atena$valor_anual[1]
tcl1 <- tcl_atena$valor_anual[2]
# buscando os valores para cálculo da TCL
cp2 <- cp_atena$valor_semestre1[1]
cp1 <- cp_atena$valor_semestre1[2]
sus1 <- sus_atena$quantidade_semestre1[3]
sus2 <- sus_atena$quantidade_semestre1[1]
tbaix2 <- tbaix_atena$valor_semestre1[1]
tbaix1 <- tbaix_atena$valor_semestre1[2]

# TpCpL
# buscando os valores já calculados do TpCp
tpcp1 <- tpcp_atena$processos[1]
tpcp2 <- tpcp_atena$processos[2]
# buscando os valores para cálculo do TpCpL
mtpcp1 <- tpcp_atena$media[1]
mtpcp2 <- tpcp_atena$media[2]

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
for (serventia in serventias$codigo_serventia[1:2]) {
  
  #construindo a url para raspar o atena
  dominio <- 'http://atena.tre-rr.jus.br'
  indicador <- '/indicadores/dashboards/litigiosidade.json?button=&per_page=30&q%5Bano_eq%5D=2022&qr%5Bcodigo_serventia_eq%5D='
  variavel <- '&qr%5Bgrau_eq%5D='
  
  url_painel_litigiosidade <- sprintf('%s%s%s%s', dominio, indicador, serventia, variavel)
  
  painel <- jsonlite::fromJSON(url_painel_litigiosidade)
  
  
  print("A serventia é")
  print(dados_serventias$codigo_serventia)
  print("O iad é")
  print(dados_serventias$iad1[dados_serventias$codigo_serventia == serventia])
  
  # obtendo o iad da 1 instancia
  dados_serventias$iad1[dados_serventias$codigo_serventia == serventia] <- painel$variaveis$valor_anual[12]
  
  # obtendo o iad da 2 instancia
  print(dados_serventias$iad2[dados_serventias$codigo_serventia == serventia] <- painel$variaveis$valor_anual[6])

  # buscar unidades do juizo digital
  print(dados_serventias$juizo_digital[dados_serventias$codigo_serventia == serventia] <- serventias$juizo_digital)

  # geolocalizar unidades judiciarias
  print(dados_serventias$longitude[dados_serventias$codigo_serventia == serventia] <- serventias$longitude)
  dados_serventias$latitude[dados_serventias$codigo_serventia == serventia] <- serventias$latitude

}

# buscando os valores já calculados do IAD
iad2 <- iad_atena$valor_anual[1]
iad1 <- iad_atena$valor_anual[2]

# buscando os valores para cálculo do IAD
cn2 <- cn_atena$valor_semestre1[1]
cn1 <- cn_atena$valor_semestre1[2]


### 
# Calculando os valores
###

# Calculando a TCL
tcl_calculada <- ((cp1+cp2)-(sus1+sus2))/((cp1+cp2)-(sus1+sus2)+(tbaix1+tbaix2))

# Calculando o IAD
iad_calculado <- (tbaix1+tbaix2)/(cn1+cn2)

# Calculando a TpCpL
tpcpl_calculado <- ((mtpcp1*cp1)+(mtpcp2*cp2))/(cp1+cp2)


# Verificando data da consulta
data <- Sys.time()
data <- as.character(data)

### 
# Guardando as variáveis obtidas
###

# montando base de dados
variaveis[nrow(variaveis) + 1,] <- data.frame(
  data = data,
  tcl_calculada = tcl_calculada,
  tcl1 = tcl1,
  tcl2 = tcl2,
  tpcpl_calculado = tpcpl_calculado,
  tpcp1 = tpcp1,
  tpcp2 = tpcp2,
  iad_calculado = iad_calculado,
  iad1 = iad1,
  iad2 = iad2,
  cp1 = cp1,
  cp2 = cp2,
  sus1 = sus1,
  sus2 = sus2,
  tbaix1 = tbaix1,
  tbaix2 = tbaix2,
  cn1 = cn1,
  cn2 = cn2
)

# guardando os dados no arquivo de variaveis
write.csv2(variaveis, 'dados/variaveis.csv', row.names = FALSE)
write.csv2(dados_serventias, 'dados/dados_serventias.csv', row.names = FALSE)

