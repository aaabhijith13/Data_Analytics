beer<- read.csv('BeerSales.csv', sep = ',', header = TRUE)
str(beer)
num_beer<- beer[ , 3:13]
str(num_beer)
cor(num_beer)

model<- lm(WeeklyVolume ~ ., data = num_beer)
summary(model)

library(fRegression)
resetTest(WeeklyVolume ~ ., data = num_beer)

library(MASS)
bc<- boxcox(model)
lambda<- bc$x[which.max(bc$y)]

num_beer2<- num_beer
num_beer2$WeeklyVolume<- log(num_beer2$WeeklyVolume)
model2<- lm(WeeklyVolume ~ ., data = num_beer2)
summary(model2)

library(car)
vif(model2)

model3<- lm(WeeklyVolume ~ Education + Income + Unemployed,
            data = num_beer2)
summary(model3)

bpTest(WeeklyVolume ~ Education + Income + Unemployed,
       varformula = ~ fitted.values(model3),
       data = num_beer2)

library(lmtest)
dwtest(WeeklyVolume ~ Education + Income + Unemployed,
       alternative = 'greater',
       data = num_beer2)

outlierTest(model3)

prediction_model<- function(income, education, unemploy) {
  int<- 0.7203
  edu<- -0.919
  inc<- 0.4527
  unem<- 4.3302
  weekVol<- (inc*income)+(edu*education)+(unem*unemploy)+int
  return(weekVol)
}
prediction_model(10, 0.05, 0.15)
prediction_model(10, 0.25, 0.2)
prediction_model(10, 0.5, 0.15)
prediction_model(20, 0.05, 0.15)


