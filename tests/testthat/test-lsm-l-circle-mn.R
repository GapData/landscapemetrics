context("landscape level circle_mn metric")

landscapemetrics_landscape_landscape_circle_mn <- lsm_l_circle_mn(landscape)

test_that("lsm_c_circle_mn is typestable", {
    expect_is(landscapemetrics_landscape_landscape_circle_mn, "tbl_df")
    expect_is(lsm_l_circle_mn(landscape_stack), "tbl_df")
    expect_is(lsm_l_circle_mn(list(landscape, landscape)), "tbl_df")
})

test_that("lsm_p_area returns the desired number of columns", {
    expect_equal(ncol(landscapemetrics_landscape_landscape_circle_mn), 6)
})

test_that("lsm_p_area returns in every column the correct type", {
    expect_type(landscapemetrics_landscape_landscape_circle_mn$layer, "integer")
    expect_type(landscapemetrics_landscape_landscape_circle_mn$level, "character")
    expect_type(landscapemetrics_landscape_landscape_circle_mn$landscape, "integer")
    expect_type(landscapemetrics_landscape_landscape_circle_mn$id, "integer")
    expect_type(landscapemetrics_landscape_landscape_circle_mn$metric, "character")
    expect_type(landscapemetrics_landscape_landscape_circle_mn$value, "double")
})

