# engine("base", type = "github", repo = "robertzk/base.sy")
engine("base", type = "local", path = "~/dev/base.sy")

.onAttach <- function(parent_engine) {
  # `director` is the base engine object.
  routes <- director$.cache$engines$base$resource("lib/controllers/routes")$value()

  parent_engine$register_preprocessor("config/routes", routes$preprocessor, overwrite = TRUE)
  parent_engine$register_parser("config/routes", routes$parser, overwrite = TRUE)

  # TODO: (RK) Fix this hack using a proper helper resource.
  environment(routes$preprocessor)$mount(parent_engine)(director)

  parent_engine$resource("config/routes")$value()

  if (interactive()) {
    Ramd::packages("crayon")
  }

  # Annoying hotfix for RCurl onLoad option setting interfering with tests.
  options(httr_oauth_cache = NULL, httr_oob_default = NULL)

  globals <- director$resource('config/global')$value(director = parent_engine)
  for (global in ls(globals)) {
    assign(global, globals[[global]], envir = globalenv()) # yuck
  }

  if (parent_engine$exists('config/global')) {
    globals <- parent_engine$resource('config/global')$value()
    for (global in ls(globals)) {
      assign(global, globals[[global]], envir = globalenv()) # yuck
    }
  }
}

