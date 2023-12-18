library(quarto)

arquivo_qmd <- here::here("praticas", "aula-4", "parametros", "apresentacao.qmd")



quarto_render(input = arquivo_qmd)

quarto_render(input = arquivo_qmd,
              execute_params = list(uf = "SP"))


# ele está gravando por cima
# não precisar trocar a variavel do parametro na mão -> purrr

quarto_render(input = arquivo_qmd,
              execute_params = list(uf = "SP"),
              output_file = "relatorio_barragens_SP.html")

# proxima etapa : tá gerando no lugar errado!!!


# exemplo com purrr
unique(barragens_filtradas[["minerio_principal"]])

nomes_colunas <- names(barragens_filtradas)

purrr::map(nomes_colunas, ~unique(barragens_filtradas[[.x]])) # usando função anonima


# voltando ...

gerar_relatorio_uf <- function(uf_filtro) {
  arquivo_qmd <-
    here::here("praticas", "aula-4", "parametros", "apresentacao.qmd")

  arquivo_html <-
    glue::glue("relatorio_barrages_{uf_filtro}.html")


  quarto_render(
    input = arquivo_qmd,
    execute_params = list(uf = uf_filtro),
    output_file = arquivo_html
  )

  # falta mover o arquivo criado!!

  fs::file_move(
    path = arquivo_html,
    new_path = paste0(
      "praticas/aula-4/parametros/",
      arquivo_html
    )

  )
}


gerar_relatorio_uf("RJ")


sigbm_bruto <- readxl::read_excel(caminho_sigbm, skip = 4) |>
  janitor::clean_names()

estados_iterar <- unique(sigbm_bruto$uf) |> sort()


walk(.x = estados_iterar, .f = gerar_relatorio_uf, .progress = TRUE)



