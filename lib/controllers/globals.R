preprocessor <- function(source_env, director, source) {
  parent.env(source_env) <- list2env(list(director = director),
                                     parent = parent.env(source_env))
  source()
}

function(input) {
  input
}

