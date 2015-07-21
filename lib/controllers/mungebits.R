# This is the mungebits controller.

preprocessor <- function(source_args, source) {
  parent.env(source_args$local) <- globalenv()
  source()
}

function(input, director) {
  simple_deflate <- director$resource("lib/shared/simple_deflate")$value()
  mungebits:::mungebit(simple_deflate(input$train), simple_deflate(input$predict))
}

