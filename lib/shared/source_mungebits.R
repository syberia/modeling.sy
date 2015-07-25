function(env, director) {
  # Add mungebits to local environment.
  mungebits <- lapply(mungebits_names <- setdiff(director$find(base = 'lib/mungebits'),
    'lib/mungebits/encode_categorical_variables'),
    function(x) director$resource(x))
  mungebits_names <- gsub('/', '.',
    sapply(mungebits_names, function(x) director:::strip_root('lib/mungebits', x)),
    fixed = TRUE)
  for (i in seq_along(mungebits))
    env[[mungebits_names[i]]] <- mungebits[[i]]
}
