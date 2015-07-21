full_deflate <- resource("lib/shared/full_deflate")

function(input) {
  force(input)
  function(munge_procedure = list(), default_args = list(), internal = list()) {
    # TODO: (RK) Better environment provisioning. If we don't include these 
    # lines, the model object may get huge due to parent environment chain
    # inclusion.
    input <- lapply(as.list(input), full_deflate)

    container <- tundra:::tundra_container$new(resource, input$train, input$predict,
      munge_procedure, full_deflate(default_args), full_deflate(internal))

    # Hooks should not have access to anything, since they will get their
    # environment injected by the tundraContainer.
    container$hooks <- lapply(container$hooks, function(fn) {
      environment(fn) <- globalenv(); fn
    })

    if (!is.null(input$read) || 
        !is.null(input$write)) {
      attr(container, "s3mpi.serialize") <- list(read = input$read, write = input$write)
    }
    container
  }
}
