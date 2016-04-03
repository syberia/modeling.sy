function(env, director) {
  # Add mungebits to local environment.
  mungebits <- lapply(mungebits_names <- director$find(base = "lib/mungebits"),
    function(x) director$resource(x))

  mungebits_names <- chartr("/", ".",
    sapply(mungebits_names, function(x) director:::strip_root("lib/mungebits", x)))

  for (i in seq_along(mungebits)) {
    env[[mungebits_names[i]]] <- mungebits[[i]]
  }
}
