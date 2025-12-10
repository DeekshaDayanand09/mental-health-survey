df_pair <- df_tech %>% filter(Country %in% c(countryA, countryB))
ctab <- table(df_pair$Country, df_pair$treatment, useNA = "no")
ctab
prop_table <- prop.table(ctab, margin = 1)
round(prop_table, 3)