if (interactive()) {
  Ramd::packages("crayon")
}

# Annoying hotfix for RCurl onLoad option setting interfering with tests.
options(httr_oauth_cache = NULL, httr_oob_default = NULL)

if (resource_exists('config/global')) {
  globals <- resource('config/global')
  for (global in ls(globals)) {
    assign(global, globals[[global]], envir = globalenv()) # yuck
  }
}

