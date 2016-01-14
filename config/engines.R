#engine("mungebits", type = "github", repo = "syberia/mungebits.sy", mount = TRUE)
engine("mungebits", type = "local", path = "~/dev/mungebits.sy", mount = TRUE)

.onAttach <- function(parent_engine) {

  # `director` is the mungebits engine object.
  routes <- director$.engines$mungebits$engine$resource("lib/controllers/routes")

  parent_engine$register_parser("config/routes", routes$parser, overwrite = TRUE)

  # TODO: (RK) Fix this hack using a proper helper resource.
  # environment(routes$preprocessor)$mount(parent_engine)(director)

  parent_engine$resource("config/routes")

  # Annoying hotfix for RCurl onLoad option setting interfering with tests.
  options(httr_oauth_cache = NULL, httr_oob_default = NULL)

  attach(director$resource("config/global/modeling", parent. = FALSE),
         name = "syberia:modeling")

  if (parent_engine$exists("config/global", children. = FALSE)) {
    attach(parent_engine$resource('config/global', director = parent_engine, children. = FALSE),
           name = "syberia:project")
  }

}

