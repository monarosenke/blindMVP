#!/usr/bin/env Rscript

rm(list=ls())
library(nlme)
library(sjstats)

main <- function() {
  dat <- read.csv(file = 'clean_data_both_hemis.csv', header = TRUE)

  df = as.data.frame(dat)
  names(df) <- c("group", "categories", "subjects", "hemi", "rsm_value")

  df$group[df$group == 1] = "blind"
  df$group[df$group == 2] = "sighted_audio"
  df$group[df$group == 3] = "sighted_video"

  df$categories[df$categories == 1] = "bodies"
  df$categories[df$categories == 2] = "scenes"
  df$categories[df$categories == 3] = "faces"
  df$categories[df$categories == 4] = "objects"

  df$hemi[df$hemi == 1] = "left"
  df$hemi[df$hemi == 2] = "right"

  df$group = as.factor(df$group)
  df$categories = as.factor(df$categories)
  df$hemi = as.factor(df$hemi)

  model <- aov(rsm_value~group + categories + hemi + group*hemi + group*categories + hemi*categories + hemi*group*categories + (1 | subjects), data=df)
  print(summary(model))
  print(summary.lm(model)) # uncomment this for huge output of estimated coefficients

  multcomp_results <- TukeyHSD(model)
  print(multcomp_results, digits=6)
  
  print(summary(model)[[1]][["Pr(>F)"]])
  print(eta_sq(model))
}

main()
