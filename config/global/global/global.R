# Any variables defined in this file will become global variables
# as soon as this project is loaded. They are meant as shortcuts / mnemonics.

`%||%` <- function(x, y) if (is.null(x)) y else x

models <- function(...) unique(gsub("^[^/]+\\/", "", director$find(..., method = "wildcard", base = "models")))
syberia_models <- models
mungebits <- function(...) director$find(..., method = 'substring', '^lib/mungebits')
classifiers <- function(...) director$find(..., method = 'substring', '^lib/classifiers')
adapters <- function(...) director$find(..., method = 'substring', '^lib/adapters')
controllers <- function(...) director$find(..., method = 'substring', '^lib/controllers')
shared <- function(...) director$find(..., method = 'substring', '^lib/shared')
stages <- function(...) director$find(..., method = 'substring', '^lib/stages')

runner <- function(version) {
  res <- Filter(function(x) grepl('^/?models/', x), director$find(version))[1]
  if (is.na(res)) stop("No model version ", sQuote(version), call. = FALSE)
  director$resource(res)
}

stest <- function(filter) {
  library(testthat)
  filter <- gsub("^\\/?test/", "", filter)
  if (missing(filter)) test_project(root()) # Run all tests in this repo
  else {
    tests <- director$find(filter, base = 'test')
    for (test in tests) director$resource(test, recompile = TRUE, recompile. = TRUE) # Run test
  }
}

reload_syberia <- function(...) {
  unloadNamespace('syberia')
  unloadNamespace('syberiaStages')
  library(syberia)
  syberia_project(root())
  invisible(TRUE)
}

test_project <- function(..., as.ci = FALSE, as.travis = as.ci) {
  if (isTRUE(as.ci) || isTRUE(as.travis)) {
    Sys.setenv(CI = "TRUE")
    on.exit(Sys.setenv(CI = ""), add = TRUE)
  }
  syberia::test_project(...)
}

last_model <- function() { director$cache_get("last_model") }
last_run <- function() { director$cache_get("last_run") }
active_runner <- function() { director$cache_get("last_model_runner") }

# Any variables defined in this file will become global variables
# as soon as this project is loaded. They are meant as shortcuts / mnemonics.

`%||%` <- function(x, y) if (is.null(x)) y else x

models <- function(...) unique(gsub("^[^/]+\\/", "", director$find(..., method = "wildcard", base = "models")))
syberia_models <- models
mungebits <- function(...) director$find(..., method = 'substring', '^lib/mungebits')
classifiers <- function(...) director$find(..., method = 'substring', '^lib/classifiers')
adapters <- function(...) director$find(..., method = 'substring', '^lib/adapters')
controllers <- function(...) director$find(..., method = 'substring', '^lib/controllers')
shared <- function(...) director$find(..., method = 'substring', '^lib/shared')
stages <- function(...) director$find(..., method = 'substring', '^lib/stages')

runner <- function(version) {
  res <- Filter(function(x) grepl('^/?models/', x), director$find(version))[1]
  if (is.na(res)) stop("No model version ", sQuote(version), call. = FALSE)
  director$resource(res)
}

stest <- function(filter) {
  library(testthat)
  filter <- gsub("^\\/?test/", "", filter)
  if (missing(filter)) test_project(root()) # Run all tests in this repo
  else {
    tests <- director$find(filter, base = 'test')    
    for (test in tests) director$resource(test, recompile = TRUE, recompile. = TRUE) # Run test
  }
}

reload_syberia <- function(...) {
  unloadNamespace('syberia')
  unloadNamespace('syberiaStages')
  library(syberia)
  syberia_project(root())
  invisible(TRUE)
}

deploy <- local({
  generate_deployment_runner <- resource("lib/shared/generate_deployment_runner")

  function(...) {
    if (is.null(director$cache_get("deploy_env"))) {
      director$cache_set("deploy_env", new.env(parent = emptyenv()))
    }
    generate_deployment_runner(..., cache_env = director$cache_get("deploy_env"))$run(verbose = TRUE)
    director$cache_set("deploy_env", new.env(parent = emptyenv()))
    invisible(TRUE)
  }
})
run_model <- define('run_model', local = TRUE)[[1]](director)
run <- run_model

makeActiveBinding("A", function() last_run()$after$data, env = globalenv())
makeActiveBinding("B", function() last_run()$before$data, env = globalenv())
makeActiveBinding("M", function() last_run()$after$model_stage$model, env = globalenv())
makeActiveBinding("S", function() active_runner(), env = globalenv())

