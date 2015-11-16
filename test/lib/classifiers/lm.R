# Test that the GBM classifier works as expected.
context("lm classifier")

test_that("it can create a simple lm tundra container", {
  expect_is(resource()(), "tundraContainer")
})

