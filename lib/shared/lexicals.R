lexicals <- list()

lexicals$`~` <- (function() {
  function(x, y = NULL) {
    try_check <- function(el, fn) tryCatch(fn(el), error = function(.) FALSE)
    suppressWarnings({
      if ((xlist <- try_check(x, is.list)) || (ylist <- try_check(y, is.list))) {
        list(x, y)
      } else if ((xfn <- try_check(x, is.function)) || (yfn <- try_check(y, is.function))) {
        mungebits2:::mungebit$new(x, y, enforce_train = FALSE)
      } else if ((xfn <- try_check(x, is.mungebit)) || (yfn <- try_check(y, is.mungebit))) {
        mungebits2:::mungebit$new(x, y, enforce_train = FALSE)
      } else {
        eval.parent(parse(text =
          paste0("(function() { `~` <- .Primitive('~')\n",
                 'structure(', paste(deparse(match.call()), collapse = "\n"),
                 ', .Environment = parent.frame()) })()'))) 
      }
    })
  }
})()

lexicals$`!` <- (function() {
  function(x) {
    if (deparse(substitute(x))[[1]] == '{') {
      fn <- function(x) {}
      body(fn) <- substitute(x)
      column_transformation(fn)
    } else if (is.function(x) && base::`!`(is.transformation(x))) {
      column_transformation(x)
    } else if (is.transformation(x)) {
      # !!{dataframe <- ...} should be a global transformation
      fnbody <- body(environment(x)$transformation)
      eval(bquote(function(dataframe, ...) eval.parent(substitute(.(fnbody)))))
    } else if (is.list(x)) {
      lapply(x, function(obj) {
        if (is.symbol(obj)) {
          get(as.character(obj), envir = parent.frame())
        } else {
          obj
        }
      })
    } else {
      base::`!`(x)
    }
  }
})()

lexicals$debug <- list(function(.) { browser() })

lexicals
