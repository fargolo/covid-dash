library(lme4)
library(ggplot2)

covid_long_d <- read.csv("data/covid-long17Mar.csv")
covid_long_d <- covid_long_d %>% 
  filter(Country %in% c('Brazil','Uruguay', 'Argentina','Chile',
                        'Paraguay','Peru','Bolivia','Ecuador','Colombia','Venezuela','Suriname'))
exp_fit <- lmer(log(val) ~ 1 + (1|Country)*diff, data=covid_long_d)

covid_long_d$exp_pred <- exp(predict(exp_fit))
ggplot(covid_long_d,aes(x=diff,y=val,color=Country))+
  geom_jitter()+
  geom_line(aes(x=diff,y=exp_pred,color=Country))
ranef(exp_fit)
