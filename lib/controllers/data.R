# The data controller.
preprocessor <- function(director, source_args) {
  # Add lexicals to local environment.
  lexicals <- director$resource('lib/shared/lexicals')$value()
  for (x in ls(lexicals)) source_args$local[[x]] <- lexicals[[x]]

  director$resource('lib/shared/source_mungebits')$value()(source_args$local, director)

  source()
}

function(director, args) {
  if (isTRUE(args$raw)) { output } # Return a list of munge_procedures
  else {
    data_stage <- director$resource('lib/stages/data')$value()

    if (is.environment(args$env)) {
      env <- args$env
    } else {
      new.env(parent = emptyenv())
    }

    data_stage(env, output, remember = !identical(args$remember, FALSE))
  }
}
