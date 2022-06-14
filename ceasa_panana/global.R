#-----------------------------------------------------------------------
#                                            Prof. Dr. Walmes M. Zeviani
#                                leg.ufpr.br/~walmes · github.com/walmes
#                                        walmes@ufpr.br · @walmeszeviani
#                      Laboratory of Statistics and Geoinformation (LEG)
#                Department of Statistics · Federal University of Paraná
#                                       2022-jun-01 · Curitiba/PR/Brazil
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Pacotes.
# install.packages('remotes')
# 
# remotes::install_github("ropensci/tabulizer")
# remotes::install_github("ropensci/tabulizerjars")

# library(tabulizer)
library(gsubfn)
library(purrr)
library(dplyr)

# setwd("./ceasa_parana")

#-----------------------------------------------------------------------
# Funções.

extract_place_date <- function(tb) {
    place <- tb |>
        grep(pattern = "CEASA", value = TRUE)
    if (length(place) == 0) {
        place <- NA_character_
    }
    # weekdays(Sys.Date() + 0:6, abbreviate = FALSE) |>
    #     paste0("-feira") |>
    #     paste(collapse = "|")
    pattern <- "(terça-feira|quarta-feira|quinta-feira|sexta-feira|sábado|domingo|segunda-feira)"
    date <- tb |>
        grep(pattern = pattern, value = TRUE)
    if (length(date) == 0) {
        pattern <- "C *O *T *A *Ç *Ã *O"
        date <- tb |>
            grep(pattern = pattern, value = TRUE)
        if (length(date) == 0) {
            date <- NA_character_
        }
    }
    data.frame(place = place[1],
               date = date[1],
               stringsAsFactors = FALSE)
}

##' extract_place_date(tb[[1]])
##' extract_place_date(tb[[2]])
##' extract_place_date(tb[[3]])
##' extract_place_date(tb[[4]])

split_product <- function(tb) {
    #----------------------------------------
    # Cria um vetor.
    x <- apply(tb,
               MARGIN = 1,
               paste,
               collapse = " ") |>
        trimws()
    #----------------------------------------
    # Identificar os blocos.
    block_header <- x |>
        grep(pattern = "^[[:upper:] ()]+$",
             value = FALSE) |>
        append(values = length(x))
    block_header <- x |>
        grep(pattern = "^[[:upper:]]{3, }.*(FIR|FRA|EST|AUS)",
             value = FALSE) |>
        append(block_header) |>
        sort()
    # x[block_header]
    if (length(block_header) <= 1) {
        return(NULL)
    }
    #----------------------------------------
    # Grupos de linhas de um mesmo bloco.
    block_data <- vector(mode = "list",
                         length = length(block_header))
    names(block_data) <-
        x[block_header] |>
        sub(pattern = "(^[[:upper:] ]+).*",
            replacement = "\\1") |>
        sub(pattern = " [[:upper:]]$", replacement = "")
    # block_data

    for (i in seq_along(block_header)[-1]) {
        index <- (block_header[i - 1]):(block_header[i] - 1)
        block_data[[i - 1]] <- x[index]
    }
    #----------------------------------------
    # Joga fora o que for vazio.
    block_data <- map(block_data,
                      function(x) {
                          x <- grep(pattern = " (FIR|FRA|EST|AUS)",
                                    value = TRUE,
                                    x = x)
                          if (length(x) == 0) return(NULL) else x
                      }) |>
        discard(is.null)
    block_data
}

##' split_product(tb[[1]])
##' split_product(tb[[2]])

extract_data <- function(string) {
    # string <- block_data[[5]]
    #----------------------------------------
    # Descrição do produto.
    pattern <- "(.*)(FIR|FRA|EST|AUS).*"
    desc <- ifelse(grepl(pattern, string),
                   sub(pattern = pattern,
                       replacement = "\\1",
                       string),
                   "") |>
        trimws()
    # desc

    #----------------------------------------
    # Condição de mercado.
    pattern <- ".*(FIR|FRA|EST|AUS).*"
    cond <- ifelse(grepl(pattern, string),
                   sub(pattern = pattern,
                       replacement = "\\1",
                       string),
                   "") |>
        trimws()
    # cond

    #----------------------------------------
    # Procedência do produto.
    pattern <- ".*[0-9-] +([[:upper:]/]+).*"
    orig <- ifelse(grepl(pattern, string),
                   sub(pattern = pattern,
                       replacement = "\\1",
                       string),
                   "") |>
        trimws()
    # orig

    #----------------------------------------
    preco <- gsubfn::strapply(string,
                              pattern = "\\d+,\\d{2}",
                              FUN = function(x) {
                                  as.numeric(sub(",", ".", x))
                              }) |>
        lapply(FUN = function(x) {
            if (length(x) >= 4) {
                matrix(head(x, n = 4), ncol = 4)
            } else {
                matrix(NA_real_, ncol = 4)
            }
        }) |>
        do.call(what = "rbind") |>
        as.data.frame() |>
        setNames(nm = c("min",
                        "mc_atual",
                        "max",
                        "mc_passado"))
    # preco

    #----------------------------------------
    bind_cols(descricao = desc,
              condicao = cond,
              origem = orig,
              preco)
}

##' tb[[1]] |>
##'     split_product() |>
##'     pluck(1) |>
##'     extract_data()

extract_ceasa_tables <- function(fl) {
    # Extração dos dados.
    tb <- extract_tables(fl) |>
        discard(~nrow(.) <= 8)
    # Extraí o local e a data.
    tb_meta <- lapply(tb, extract_place_date) |>
        bind_rows() |>
        drop_na() |>
        head(1) |>
        rename(produto = 1, descricao = 2)
    # Extrai a tabela com produtos e preços.
    tb_prod <- map(tb, split_product) |>
        unlist(recursive = FALSE) |>
        map(extract_data) |>
        bind_rows(.id = "produto")
    # Retorna com local e data na primeira linha.
    bind_rows(tb_meta, tb_prod)
}

##' fl <- "cotacaopdf31052022.pdf"
##'
##' # Extração dos dados.
##' tb <- extract_tables(fl) |>
##'     discard(~nrow(.) <= 8)
##' str(tb)
##'
##' map(tb, split_product) |>
##'     unlist(recursive = FALSE) |>
##'     map(extract_data) |>
##'     bind_rows()

#-----------------------------------------------------------------------
