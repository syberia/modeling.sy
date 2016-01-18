optional_tests <- c("lib/controllers", "lib/shared/gbm_parameters",
                    "lib/shared/lexicals", "lib/shared/source_mungebits")

if (!nzchar(Sys.getenv("CI"))) {
  ignored_tests <- "models"
}

# Test setup hooks
setup <- Ramd::define("setup_import_data", function(setup_import_data) {
  list("Announce tests"                     = function(env) cat("Running tests...\n"),
       "Setup import_data for models"       = setup_import_data(director, optional_tests)
  )
})

# Test teardown hooks
teardown <- list(
  "All tests ran" = function(env) {
    cat(crayon::magenta("All tests ran.\n"))
  }
)

single_setup <- list(
  "Announce test" = function(env) {
    cat("Testing ", sQuote(env$resource), "...\n")
  }
)

