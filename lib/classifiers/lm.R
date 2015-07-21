train <- function(dataframe) {
  output <<- list(model = lm(dep_var ~ ., data = dataframe))
}

predict <- function(dataframe) {
  predict(output$model, newdata = dataframe)
}
