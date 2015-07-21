# An example classifier for stubbing and testing.

train <- predict <- function(dataframe, ...) {
  output <<- list(model = NULL)
  runif(NROW(dataframe), 0, 1)
}

