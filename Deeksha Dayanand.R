library(readr)
library(dplyr)
library(janitor)
library(stringr)    
df <- read_csv("survey.csv", show_col_types = FALSE)
dim(df)
glimpse(df)
colnames(df)


df %>% count(tech_company) %>% arrange(desc(n))
df %>% count(treatment) %>% arrange(desc(n))
df <- df %>%
  mutate(
    tech_company = str_trim(str_to_title(tech_company)),
    treatment   = str_trim(str_to_title(treatment)),
    Country     = str_trim(Country)
  )