library(xtable)

dat <- read.csv("./data/testdata.csv")

reg <- lm(dat$rnorm.100..100. ~ dat$rnorm.100..10.)

#NOTE that it is very helpful to label your tables and figures so that you can
#reference them from anywhere in a document when in Latex and it will always
#reference them by the proper order. No more checking through to make sure figure numbers
#are correct after reording them!

print(xtable(summary(reg)$coefficients, 
        type = "latex",
        caption = "Results from a regression of a simulated vector of deviates from a normal distribution centered at 100 against deviates from a normal distribution centered at 10. xtable is awesome!",
        label = "table:lm_results",
        digits = 2), #round to the correct number of digits automatically
      file = "./results/lm_results.tex",
      floating.environment='table', #Can change to sideways table if landscape format desired
      include.rownames = FALSE)