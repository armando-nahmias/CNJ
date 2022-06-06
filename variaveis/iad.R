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
library("jsonlite")
library('comprehenr')
library('tibble')

url_serventias <- paste(dominio, '/indicadores/serventias.json', sep = '')

serventias <- jsonlite::fromJSON(url_serventias)


serventia <- data.frame(
  codigo_serventia = serventias$codigo_serventia,
  descricao_serventia = serventias$descricao
)

for (item in serventia$codigo_serventia) {
   
  dominio <- 'http://atena.tre-rr.jus.br'
  indicador <- '/indicadores/dashboards/litigiosidade.json?button=&per_page=30&q%5Bano_eq%5D=2022&qr%5Bcodigo_serventia_eq%5D='
  variavel <- '&qr%5Bgrau_eq%5D='

  url_painel_litigiosidade <- sprintf('%s%s%s%s', dominio, indicador, item, variavel)

  painel <- jsonlite::fromJSON(url_painel_litigiosidade)
  
  print(serventia$codigo_serventia)
  print(serventia$iad1[serventia$codigo_serventia == item])
  serventia$iad1[serventia$codigo_serventia == item] <- painel$variaveis$valor_anual[12]

  serventia$iad2[serventia$codigo_serventia == item] <- painel$variaveis$valor_anual[6]
  
}

