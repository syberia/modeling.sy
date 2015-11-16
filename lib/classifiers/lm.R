train <- function(dataframe) {
  output <<- list(model = lm(dep_var ~ ., data = dataframe))
}

predict <- function(dataframe) {
  unname(stats::predict(output$model, newdata = dataframe))
}
