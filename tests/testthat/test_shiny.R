context("test shiny")

# Load Shiny
shiny_test <- callr::r_process$new(
  callr::r_process_options(func = function(){
    shiny::runApp(system.file("shiny", package = "d3tm"),
                  port = 4446L,
                  launch.browser = FALSE)
  })
)

# Load R Selenium
opts <- callr::r_process_options(
  func = function(){
    system("java -jar /bin/selenium-server-standalone-3.9.1.jar")
  },
  supervise = TRUE,
  stdout = tempfile("webdriver-stdout-", fileext = ".log"),
  stderr = tempfile("webdriver-stderr-", fileext = ".log")
)

handle <- callr::r_process$new(opts)
Sys.sleep(5)

# Connect with Chrome Headless
library(RSelenium)
eCaps <- list(chromeOptions = list(
  args = c('--headless', '--disable-gpu', '--window-size=1280,800')
))

rD <- remoteDriver(port = 4444L, browser = "chrome",
                   extraCapabilities = eCaps)


test_that("Test Application Has Loaded",{
  rD$open(silent = TRUE)
  rD$navigate("http://127.0.0.1:4446")
  appTitle <- rD$getTitle()[[1]]
  expect_equal(appTitle, "Test App")
  rD$close()
})

handle$kill()
rm(handle, rD)
gc()

