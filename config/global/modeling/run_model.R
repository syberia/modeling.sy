#' Build a model using a data source from scratch.
#' 
#' TODO: (RK) Document this method more.
#' 
#' @param key a string or list. If the former, there must be a
#'   file with name \code{model_stages} followed by \code{.r} so that syberia
#'   can read the model configurations.
#' @param ... additional arguments to pass to \code{$run(...)} on the stageRunner.
#'   For example, \code{to = 'some/key'}.
#' @param fresh logical. Whether or not to use the cache. By default, \code{FALSE}.
#' @param verbose logical. Whether or not to display messages. The default is
#'   \code{TRUE}.
#' @param director director. The director object used to find relevant models.
#' @param method character. The method used to look up relevant models, either
#'   \code{"wildcard"}, \code{"partial"}, or \code{"exact"}, by default the former.
#'   See also \link[director]{director_find}.
#' @export
run_model <- function(key = director$cache_get("last_key"), ..., fresh = FALSE,
                      verbose = TRUE, director = syberia::active_project(), method = 'wildcard') {
  if (missing(key)) { key <- director$cache_get("last_key") }
  if (!is.character(key)) { stop("No model executed.", call. = FALSE) }
  director$cache_set("last_key", key)

  keys <- director$find(key, base = 'models', method = method)
  if (length(keys) == 0) {
    stop("No model ", sQuote(key),
         " found in syberia project ", sQuote(director$root()), call. = FALSE)
  }
  
  # Construct the stageRunner and then execute it.
  invisible(director$cache_set("last_run",
    director$resource(keys[1])$run(..., verbose = verbose))[[1L]])
}

