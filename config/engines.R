# engine("base", type = "github", repo = "robertzk/base.sy")
engine("base", type = "local", path = "~/dev/base.sy", mount = TRUE)

.onAttach <- function(parent_engine) {
  # `director` is the base engine object.
  routes <- director$.engines$base$engine$resource("lib/controllers/routes")

  parent_engine$register_parser("config/routes", routes$parser, overwrite = TRUE)

  # TODO: (RK) Fix this hack using a proper helper resource.
  # environment(routes$preprocessor)$mount(parent_engine)(director)

  parent_engine$resource("config/routes")

  # Annoying hotfix for RCurl onLoad option setting interfering with tests.
  options(httr_oauth_cache = NULL, httr_oob_default = NULL)

  globals <- director$resource('config/global', director = parent_engine)
  for (global in ls(globals)) {
    assign(global, globals[[global]], envir = globalenv()) # yuck
  }

  if (parent_engine$exists('config/global')) {
    globals <- parent_engine$resource('config/global')
    for (global in ls(globals)) {
      assign(global, globals[[global]], envir = globalenv()) # yuck
    }
  }
}
