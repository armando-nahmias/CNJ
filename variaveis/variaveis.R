install.packages("jsonlite")
install.packages("comprehenr")
library("jsonlite")
library('comprehenr')



# carregando arquivo
if (file.exists('dados/variaveis.csv')) {
  variaveis <- read.csv2('dados/variaveis.csv')
} else {
    variaveis <- data.frame(
      data = character(),
      tcl_calculada = numeric(),
      iad_calculado = numeric(),
      tpcpl_calculado = numeric(),
      tcl1 = numeric(),
      tcl2 = numeric(),
      tpcp1 = integer(),
      tpcp2 = integer(),
      cp1 = integer(),
      cp2 = integer(),
      sus1 = integer(),
      sus2 = integer(),
      tbaix1 = integer(),
      tbaix2 = integer(),
      cn1 = integer(),
      cn2 = integer(),
      iad1 = numeric(),
      iad2 = numeric()
    )
}






url <- list(
  # Variáveis 2022
  url_tcl_2022 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=tcl',
  url_cp_2022 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=cp',
  url_tpcp_2022 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/tempo.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bjurisdicao_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=tpcp&qr%5Bcodigo_serventia_eq%5D=',
  url_sus_2022 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores.json?button=&page=1&per_page=30&q%5Banexo_eq%5D=&q%5Bano_eq%5D=2022&q%5Bgrupo_id_eq%5D=&q%5Bjurisdicao_eq%5D=&q%5Bs%5D=&q%5Btipo_eq%5D=&q%5Bvariavel_i_cont%5D=sus',
  url_tbaix_2022 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=tbaix',
  url_iad_2022 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=iad',
  url_cn_2022 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2022&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=cn',

  # Variáveis 2021
  url_tcl_2021 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2021&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=tcl',
  url_cp_2021 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2021&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=cp',
  url_tpcp_2021 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/tempo.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2021&q%5Bjurisdicao_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=tpcp&qr%5Bcodigo_serventia_eq%5D=',
  url_sus_2021 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores.json?button=&page=1&per_page=30&q%5Banexo_eq%5D=&q%5Bano_eq%5D=2021&q%5Bgrupo_id_eq%5D=&q%5Bjurisdicao_eq%5D=&q%5Bs%5D=&q%5Btipo_eq%5D=&q%5Bvariavel_i_cont%5D=sus',
  url_tbaix_2021 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2021&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=tbaix',
  url_iad_2021 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2021&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=iad',
  url_cn_2021 <- 'http://atena.tre-rr.jus.br/indicadores/indicadores/litigiosidade.json?button=&page=1&per_page=30&q%5Bano_eq%5D=2021&q%5Bcategoria_id_eq%5D=&q%5Bs%5D=&q%5Bvariavel_i_cont%5D=cn'
)


# buscando variáveis do Atena
tcl_atena_2022 <- jsonlite::fromJSON(url_tcl_2022)
tcl_atena_2021 <- jsonlite::fromJSON(url_tcl_2021)
cp_atena <- jsonlite::fromJSON(url_cp_2022)
tpcp_atena <- jsonlite::fromJSON(url_tpcp_2022)
sus_atena <- jsonlite::fromJSON(url_sus_2022)
tbaix_atena <- jsonlite::fromJSON(url_tbaix_2022)
iad_atena <- jsonlite::fromJSON(url_iad_2022)
cn_atena <- jsonlite::fromJSON(url_cn_2022)

# buscando os valores já calculados do IAD
iad2 <- iad_atena$valor_semestre1[1]
iad1 <- iad_atena$valor_semestre1[2]

# buscando os valores já calculados do TpCp
tpcp1 <- tpcp_atena$processos[1]
tpcp2 <- tpcp_atena$processos[2]

# buscando os valores já calculados da TCL
tcl2 <- tcl_atena$valor_semestre1[1]
tcl1 <- tcl_atena$valor_semestre1[2]

# buscando os valores para cálculo da TCL
cp2 <- cp_atena$valor_semestre1[1]
cp1 <- cp_atena$valor_semestre1[2]
sus1 <- sus_atena$quantidade_semestre1[3]
sus2 <- sus_atena$quantidade_semestre1[1]
tbaix2 <- tbaix_atena$valor_semestre1[1]
tbaix1 <- tbaix_atena$valor_semestre1[2]

# buscando os valores para cálculo do IAD
cn2 <- cn_atena$valor_semestre1[1]
cn1 <- cn_atena$valor_semestre1[2]

# buscando os valores para cálculo do TpCpL
mtpcp1 <- tpcp_atena$media[1]
mtpcp2 <- tpcp_atena$media[2]


# Calculando a TCL
tcl_calculada <- ((cp1+cp2)-(sus1+sus2))/((cp1+cp2)-(sus1+sus2)+(tbaix1+tbaix2))

# Calculando o IAD
iad_calculado <- (tbaix1+tbaix2)/(cn1+cn2)

# Calculando a TpCpL
tpcpl_calculada <- ((mtpcp1*cp1)+(mtpcp2*cp2))/(cp1+cp2)


# Verificando data da consulta
data <- Sys.time()
data <- as.character(data)

# montando base de dados
variaveis[nrow(variaveis) + 1,] <- data.frame(
  data = data,
  tcl_calculada = tcl_calculada,
  iad_calculado = iad_calculado,
  tcl1 = tcl1,
  tcl2 = tcl2,
  cp1 = cp1,
  cp2 = cp2,
  sus1 = sus1,
  sus2 = sus2,
  tbaix1 = tbaix1,
  tbaix2 = tbaix2,
  cn1 = cn1,
  cn2 = cn2,
  iad1 = iad1,
  iad2 = iad2
)

str(variaveis)

variaveis

write.csv2(variaveis, 'dados/variaveis.csv', row.names = FALSE)
