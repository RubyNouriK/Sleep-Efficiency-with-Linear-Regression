## --------------------------------------------------------------------------------------
suppressWarnings({
  library(lubridate)
  library(mctest)
  library(olsrr)
  library(ggplot2)
  library(lmtest)
})


## --------------------------------------------------------------------------------------
sleep_data = read.csv("Sleep_Efficiency.csv")
head(sleep_data)


## --------------------------------------------------------------------------------------
str(sleep_data)


## --------------------------------------------------------------------------------------
sleep_data$Bedtime = trimws(sleep_data$Bedtime)
sleep_data$Wakeup.time = trimws(sleep_data$Wakeup.time)


## --------------------------------------------------------------------------------------
sleep_data[is.na(sleep_data)] = 0


## --------------------------------------------------------------------------------------
sleep_data$Bedtime = mdy_hms(sleep_data$Bedtime, tz="UTC")
sleep_data$Wakeup.time = mdy_hms(sleep_data$Wakeup.time, tz="UTC")


## --------------------------------------------------------------------------------------
str(sleep_data)


## --------------------------------------------------------------------------------------
head(sleep_data)


## --------------------------------------------------------------------------------------
sleep_data$Bedtime_hour = format(sleep_data$Bedtime, format = "%H:%M")
sleep_data$Wakeup.time_hour = format(sleep_data$Wakeup.time, format = "%H:%M")


## --------------------------------------------------------------------------------------
head(sleep_data)


## --------------------------------------------------------------------------------------
# Extract hour and minute from bedtime
sleep_data$Bedtime_hour = hour(sleep_data$Bedtime) + (minute(sleep_data$Bedtime) / 60)

# Extract hour and minute from wakeup time
sleep_data$Wakeup.time_hour = hour(sleep_data$Wakeup.time) + (minute(sleep_data$Wakeup.time) / 60)


## --------------------------------------------------------------------------------------
# Ensure Bedtime_hour and wakeup.time_hour are numeric
sleep_data$Bedtime_hour = as.numeric(sleep_data$Bedtime_hour)
sleep_data$Wakeup.time_hour = as.numeric(sleep_data$Wakeup.time_hour)

# Adjust bedtimes: Add 24 hours if bedtime is after midnight (before noon)
sleep_data$Bedtime_adj = ifelse(sleep_data$Bedtime_hour < 12, 
                                 sleep_data$Bedtime_hour + 24, 
                                 sleep_data$Bedtime_hour)

# Doing the same for the wakeup.time_hour
sleep_data$wakeup.time_adj = ifelse(sleep_data$Wakeup.time_hour < 12, 
                                 sleep_data$Wakeup.time_hour + 24, 
                                 sleep_data$Wakeup.time_hour)


# Find the new earliest bedtime and set the reference
earliest_bedtime = min(sleep_data$Bedtime_adj, na.rm = TRUE)
# 1 hour before the earliest bedtime
reference_time = earliest_bedtime - 1

# Compute shifted bedtime
# (reference time of the wake up time will be the same as the bedtime)
sleep_data$Bedtime_shifted = sleep_data$Bedtime_adj - reference_time
sleep_data$Wakeuptime_shifted = sleep_data$wakeup.time_adj - reference_time


## --------------------------------------------------------------------------------------
# Drop the columns "Bedtime_hour","Wakeup.time_hour", "Bedtime_adj" and "wakeup.time_adj"

drop = c("Bedtime_hour","Wakeup.time_hour","Bedtime_adj","wakeup.time_adj")

sleep_data = sleep_data[,!(names(sleep_data) %in% drop)]


## --------------------------------------------------------------------------------------
head(sleep_data)


## --------------------------------------------------------------------------------------
full_model = lm(Sleep.efficiency ~ Age + factor(Gender) + Sleep.duration + REM.sleep.percentage + Deep.sleep.percentage + Light.sleep.percentage + Awakenings + Caffeine.consumption + Alcohol.consumption + factor(Smoking.status) + Exercise.frequency + Bedtime_shifted + Wakeuptime_shifted, data = sleep_data)

summary(full_model)


## --------------------------------------------------------------------------------------
ggplot(full_model, aes(x=.fitted, y=.resid)) +
geom_point() +geom_smooth()+
geom_hline(yintercept = 0)


## --------------------------------------------------------------------------------------
pairs(~Sleep.efficiency + REM.sleep.percentage + Light.sleep.percentage + Deep.sleep.percentage, data = sleep_data)


## --------------------------------------------------------------------------------------
suppressWarnings({
  imcdiag(full_model, method="VIF")
})


## --------------------------------------------------------------------------------------
full_model_rem_deep = lm(Sleep.efficiency ~ Age + factor(Gender) + Sleep.duration + REM.sleep.percentage+ Deep.sleep.percentage + Awakenings + Caffeine.consumption + Alcohol.consumption + factor(Smoking.status) + Exercise.frequency + Bedtime_shifted + Wakeuptime_shifted, data = sleep_data)

imcdiag(full_model_rem_deep, method="VIF")
summary(full_model_rem_deep)


## --------------------------------------------------------------------------------------
full_model_rem_deep = lm(Sleep.efficiency ~ Age + Gender + Sleep.duration + REM.sleep.percentage+ Deep.sleep.percentage + Awakenings + Caffeine.consumption + Alcohol.consumption + Smoking.status + Exercise.frequency + Bedtime_shifted + Wakeuptime_shifted, data = sleep_data)

full_model_rem_deep_wise = ols_step_both_p(full_model_rem_deep,p_enter = 0.05, p_remove = 0.3, details=FALSE)

summary(full_model_rem_deep_wise$model)


## --------------------------------------------------------------------------------------
full_model_rem_deep = lm(formula = Sleep.efficiency ~ Age + (Gender) + Sleep.duration + 
    REM.sleep.percentage + Deep.sleep.percentage + Awakenings + 
    Caffeine.consumption + Alcohol.consumption + (Smoking.status) + 
    Exercise.frequency + Bedtime_shifted + Wakeuptime_shifted, 
    data = sleep_data)
ExecSubsets=ols_step_best_subset(full_model_rem_deep, details=TRUE)


## --------------------------------------------------------------------------------------
ExecSubsets


## --------------------------------------------------------------------------------------
fulladditivemodel = lm(Sleep.efficiency ~ Age + REM.sleep.percentage + Deep.sleep.percentage + Awakenings + Alcohol.consumption + factor(Smoking.status) + Exercise.frequency, data=sleep_data)

summary(fulladditivemodel)


## --------------------------------------------------------------------------------------
anova(fulladditivemodel, full_model)


## --------------------------------------------------------------------------------------
full_interaction_model = lm(Sleep.efficiency ~ (Age + REM.sleep.percentage + Deep.sleep.percentage + Awakenings + Alcohol.consumption + Smoking.status + Exercise.frequency)^2, data=sleep_data)

summary(full_interaction_model)


## --------------------------------------------------------------------------------------
interaction_step = ols_step_both_p(full_interaction_model, p_enter=0.05, p_remove=0.1, details=FALSE)
summary(interaction_step$model)


## --------------------------------------------------------------------------------------
interactionmodel = lm(Sleep.efficiency ~ REM.sleep.percentage + Age + Awakenings + Exercise.frequency + factor(Smoking.status) + Alcohol.consumption + Deep.sleep.percentage + factor(Smoking.status)*Deep.sleep.percentage + Awakenings*Deep.sleep.percentage + Age*Deep.sleep.percentage + REM.sleep.percentage*Awakenings, data = sleep_data)

ggplot(interactionmodel, aes(x=.fitted, y=.resid)) +
geom_point() +
geom_smooth() +
geom_hline(yintercept=0)


## --------------------------------------------------------------------------------------
pairs(~Sleep.efficiency + Age + REM.sleep.percentage + Deep.sleep.percentage, data=sleep_data)

pairs(~Sleep.efficiency + Awakenings + Alcohol.consumption + factor(Smoking.status) + Exercise.frequency, data=sleep_data)


## --------------------------------------------------------------------------------------
model1 = lm(Sleep.efficiency ~ REM.sleep.percentage + Age + Awakenings + Exercise.frequency + Smoking.status + Alcohol.consumption + Deep.sleep.percentage + Smoking.status*Deep.sleep.percentage + Awakenings*Deep.sleep.percentage + Age*Deep.sleep.percentage + REM.sleep.percentage*Awakenings + I(Deep.sleep.percentage^2) + I(Deep.sleep.percentage^3) + I(Awakenings^2) + I(Awakenings^3) + I(Awakenings^4), data=sleep_data)

summary(model1)
bptest(model1)
shapiro.test(residuals(model1))


## --------------------------------------------------------------------------------------
model2 = lm(Sleep.efficiency ~ REM.sleep.percentage + Age + Awakenings + Exercise.frequency + Smoking.status + Alcohol.consumption + Deep.sleep.percentage + Smoking.status*Deep.sleep.percentage + Awakenings*Deep.sleep.percentage + Age*Deep.sleep.percentage + REM.sleep.percentage*Awakenings + I(Awakenings^2) + I(Awakenings^3) + I(Awakenings^4) + I(Deep.sleep.percentage^2) + I(Deep.sleep.percentage^3) + I(Age^2), data = sleep_data)

summary(model2)
bptest(model2)
shapiro.test(residuals(model2))


## --------------------------------------------------------------------------------------
model3 = lm(Sleep.efficiency~REM.sleep.percentage+Age+Awakenings+Exercise.frequency+Smoking.status+Alcohol.consumption+Deep.sleep.percentage+Smoking.status*Deep.sleep.percentage+Awakenings*Deep.sleep.percentage+Age*Deep.sleep.percentage+REM.sleep.percentage*Awakenings+I(Age^2)+I(Age^3)+I(Age^4)+I(Age^5)+I(Deep.sleep.percentage^2)+I(Deep.sleep.percentage^3)+I(Deep.sleep.percentage^4)+I(Deep.sleep.percentage^5), data=sleep_data)
summary(model3)
bptest(model3)
shapiro.test(residuals(model3))


## --------------------------------------------------------------------------------------
ggplot(model1, aes(x=.fitted, y=.resid)) +
geom_point() +
geom_smooth() +
geom_hline(yintercept=0)

ggplot(model2, aes(x=.fitted, y=.resid)) +
geom_point() +
geom_smooth() +
geom_hline(yintercept=0)

ggplot(model3, aes(x=.fitted, y=.resid)) +
geom_point() +
geom_smooth() +
geom_hline(yintercept=0)


## --------------------------------------------------------------------------------------
plot(model1 ,which=5)
plot(model2, which=5)
plot(model3, which=5)


## --------------------------------------------------------------------------------------
ggplot(model1, aes(x=.fitted, y=.resid)) +
geom_point(colour = "blue") +
geom_hline(yintercept = 0) +
geom_smooth(colour = "maroon") +
ggtitle("Residual Plot: Residual vs Fitted Values (model1)")

ggplot(model2, aes(x=.fitted, y=.resid)) +
geom_point(colour = "purple") +
geom_hline(yintercept = 0) +
geom_smooth(colour = "green4") +
ggtitle("Residual Plot: Residual vs Fitted Values (model2)")

ggplot(model3, aes(x=.fitted, y=.resid)) +
geom_point(colour = "cyan3") +
geom_hline(yintercept = 0) +
geom_smooth(colour = "orange2") +
ggtitle("Residual Plot: Residual vs Fitted Values (model3)")

ggplot(model1, aes(x=.fitted, y=sqrt(abs(.stdresid)))) +
  geom_point(colour = "blue") +
  geom_hline(yintercept = 0) +
  geom_smooth( colour = "maroon")+
   ggtitle("Scale-Loc. plot : Standardized Residual vs Fitted Values (model1)")

ggplot(model2, aes(x=.fitted, y=sqrt(abs(.stdresid)))) +
  geom_point(colour = "purple") +
  geom_hline(yintercept = 0) +
  geom_smooth( colour = "green4")+
   ggtitle("Scale-Loc. plot : Standardized Residual vs Fitted Values (model2)")

ggplot(model3, aes(x=.fitted, y=sqrt(abs(.stdresid)))) +
  geom_point(colour = "cyan3") +
  geom_hline(yintercept = 0) +
  geom_smooth( colour = "orange2")+
   ggtitle("Scale-Loc. plot : Standardized Residual vs Fitted Values (model3)")


## --------------------------------------------------------------------------------------
bptest(model1)
bptest(model2)
bptest(model3)


## --------------------------------------------------------------------------------------
ggplot(sleep_data, aes(sample=model1$residuals)) +
stat_qq() +
stat_qq_line()+labs(title="Model 1")

ggplot(sleep_data, aes(sample=model2$residuals)) +
stat_qq() +
stat_qq_line()+labs(title="Model 2")

ggplot(sleep_data, aes(sample=model3$residuals)) +
stat_qq() +
stat_qq_line()+labs(title="Model 3")


## --------------------------------------------------------------------------------------
shapiro.test(residuals(model1))
shapiro.test(residuals(model2))
shapiro.test(residuals(model3))

