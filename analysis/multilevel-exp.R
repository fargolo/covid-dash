library(lme4)
library(ggplot2)
library(tidyr)
library(dplyr)
covid_long_d <- read.csv("../data/covid-long17Mar.csv")
covid_long_d <- covid_long_d %>% 
  filter(Country %in% c('Brazil','Uruguay', 'Argentina','Chile',
                        'Paraguay','Peru','Bolivia','Ecuador','Colombia','Venezuela','Suriname'))
exp_fit <- lmer(log(val) ~ 1 +(1|Country)*diff, data=covid_long_d)

covid_long_d$exp_pred <- exp(predict(exp_fit))
p <- ggplot(covid_long_d,aes(x=diff,y=val,color=Country))+
  geom_jitter()+
  geom_line(aes(x=diff,y=exp_pred,color=Country))+
  ggthemes::theme_economist_white(gray_bg = F)+
  ylab("Cases")+xlab("Days since first case")

ggsave(p,filename = "../images/hierarch.png",type="cairo-png",
       dpi = 300,units = "cm",width = 20, height = 10)
write.csv(ranef(exp_fit),"../data/fit_data17Mar.csv")
write.csv(covid_long_d,"../data/fit_plot17Mar.csv")
