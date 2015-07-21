simple_deflate <- resource("lib/shared/simple_deflate")

function(final_obj) {
  # We need to make sure we're not storing the entire parent environment chain
  # when later serializing a tundraContainer.
  deflate <- function(obj) {
    if (is.list(obj)) {
      # Do not use lapply so that we preserve attributes.
      for (i in seq_along(obj)) {
        obj[[i]] <- Recall(obj[[i]])
      }
      obj
    } else if (is.function(obj)) {
      simple_deflate(obj)
    } else obj
  }
  deflate(final_obj)
}

