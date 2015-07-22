# This is the mungebits controller.

preprocessor <- function(source_env, source) {
  parent.env(source_env) <- globalenv()
  source()
}

function(input, director) {
  simple_deflate <- director$resource("lib/shared/simple_deflate")
  mungebits:::mungebit(simple_deflate(input$train), simple_deflate(input$predict))
}

