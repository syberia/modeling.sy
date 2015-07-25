# This is the mungebits controller.

function(input, director) {
  simple_deflate <- director$resource("lib/shared/simple_deflate")
  mungebits:::mungebit(simple_deflate(input$train), simple_deflate(input$predict))
}

