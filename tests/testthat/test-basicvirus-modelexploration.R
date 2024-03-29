context("test-basicvirus-modelexploration.R")

test_that("test that modelexploration app returns the proper plots",
          {

            modelsettings = list()
            modelsettings$simfunction = 'simulate_basicvirus_modelexploration'

            #use default values for simulation function,
            #they need to be part of modelsettings otherwise run_model won't work
            defpar = formals(modelsettings$simfunction)
            modelsettings = c(modelsettings,defpar)

            #replace some model settings with non-default values
            modelsettings$samples = 10
            modelsettings$parmin = 1e-07
            modelsettings$parmax = 1e-06
            modelsettings$samplepar = "b"
            modelsettings$pardist = "lin"

            modelsettings$tstart = 0
            modelsettings$tfinal = 200
            modelsettings$dt = 0.1
            modelsettings$rngseed = 100

            modelsettings$modeltype = '_modelexploration_'
            modelsettings$nplots = 1
            modelsettings$plotscale = 'x'

            result = run_model(modelsettings)

            p = DSAIRM::generate_ggplot(result)
            testthat::expect_true( ggplot2::is.ggplot(p))

            testthat::expect_is( generate_plotly(result), "plotly" )
            testthat::expect_is( generate_text(result), "html" )
            testthat::expect_is( generate_text(result), "character" )


            modelsettings$pardist = "log"
            modelsettings$samplepar = "g"
            modelsettings$parmin = 1e-07
            modelsettings$parmax = 1e-06
            result = run_model(modelsettings)

            p = DSAIRM::generate_ggplot(result)
            testthat::expect_true( ggplot2::is.ggplot(p))

            modelsettings$samplepar = "dI"
            modelsettings$parmin = 1e-1
            modelsettings$parmax = 1
            modelsettings$samples = 10
            modelsettings$tfinal = 10
            result = run_model(modelsettings)

            expect_true(grepl("10 times",result[[1]]$finaltext))


            })

