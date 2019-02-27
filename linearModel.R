library(xtable)

dat <- read.csv("./data/testdata.csv")

reg <- lm(dat$rnorm.100..100. ~ dat$rnorm.100..10.)

print(xtable(summary(reg)$coefficients, 
      type = "latex"),
      file = "./results/lm_results.tex",
      floating.environment='table', #Can change to sideways table if landscape format desired
      include.rownames = FALSE)