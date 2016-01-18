
test_that("it is a stageRunner with some sources provided", {
  expect_is(resource()(c("transunion313", "clarity")), "stageRunner")
})

