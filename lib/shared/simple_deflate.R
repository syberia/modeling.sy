# Deflate functions for mungebits and column transformations from becoming
# too large when serializing due to parent environment chains.

sanitize <- function(fn) {
  # Only sanitize non-namespace functions (functions in packages do not
  # need deflation!).
  if (is.function(fn) && !isNamespace(environment(fn))) {
    env <- if (is.null(environment(fn))) new.env() else environment(fn)
    function_vars <- function(fn) {
      if (!is.function(fn)) return(character(0))
      used_vars <- all.names(body(fn))
      
      # Quick and dirty environment hijacking.
      setdiff(intersect(used_vars, ls(env)), names(formals(fn)))
    }

    # Retain the helpers used by each helper function as well until it
    # converges.
    previous_used_vars <- character(0)
    used_vars <- function_vars(fn)
    while (!setequal(previous_used_vars, used_vars)) {
      new_vars <- setdiff(used_vars, previous_used_vars)
      previous_used_vars <- used_vars
      used_vars <- union(used_vars,
        Reduce(c, lapply(mget(new_vars, envir = env), function_vars)))
    }
    
    # First, grab the variables used by the closure.
    deflated_env <- list2env(mget(used_vars, envir = env), parent = globalenv())

    # Next, set the environment of *helper* functions to the same environment
    # to prevent helper functions from carrying parent environment chains.
    for (el in base::ls(deflated_env, all = TRUE)) {
      if (is.function(deflated_env[[el]])) {
        environment(deflated_env[[el]]) <- deflated_env
      }
    }
    environment(fn) <- deflated_env
  }
  fn
}

function(obj) {
  if (is.function(obj)) {
    env <- environment(obj)
    if (!is.null(env) && base::exists("transformation", envir = env)) {
      stopifnot(is.function(env$transformation))
      env$transformation <- sanitize(env$transformation)
    }
  }
  sanitize(obj)
}

