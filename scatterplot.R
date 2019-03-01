dat <- read.csv("./data/testdata.csv")

 
pdf(width = 8, 
    height = 8,
    file = "./results/scatterplot.pdf")
plot(dat$rnorm.100..100.,
     dat$rnorm.100..10.,
     main = "",
     xlab = "fake data",
     ylab = "more fake data")
dev.off()
