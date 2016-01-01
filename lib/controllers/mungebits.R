# This is the mungebits controller.

function(input, director) {
  simple_deflate <- director$resource("lib/shared/simple_deflate")
  mungebits2::mungebit$new(simple_deflate(input$train), simple_deflate(input$predict))
}

