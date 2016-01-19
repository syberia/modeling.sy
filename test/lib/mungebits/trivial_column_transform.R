test_that("it reverses some columns in the dataframe", {
  bit <- resource()
  iris2 <- iris
  expect_true(FALSE)
  iris2[1:2] <- lapply(iris[1:2], rev)
  expect_equal(bit$run(iris, 1:2), iris2)
  expect_equal(bit$run(iris, 1:2), iris2)
})

