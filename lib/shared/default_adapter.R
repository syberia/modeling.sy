# The default IO adapter to use. If your syberia project's
# \code{"config/application.R"} has a \code{default_adapter} defined,
# it will be that; otherwise, it will be the file adapter.
local({
  `%||%` <- function(x, y) if (is.null(x)) y else x
  default_value <- NULL
  function() {
    default_value <<- default_value %||%
      resource('config/application')$default_adapter %||% 'file'
  }
})()
