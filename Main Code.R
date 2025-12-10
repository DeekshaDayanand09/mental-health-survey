setwd("D:/R")


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


df_tech <- df %>% filter(tech_company == "Yes")
dim(df_tech)
df_tech %>% count(tech_company)


top_countries <- df_tech %>%
  filter(!is.na(Country) & Country != "") %>%
  mutate(Country = str_squish(Country)) %>% 
  count(Country, sort = TRUE)
top_countries %>% slice(1:10)
countryA <- top_countries$Country[1]
countryB <- top_countries$Country[2]
countryA; countryB
df_tech <- df_tech %>%
  mutate(Country = case_when(
    Country %in% c("USA", "United States of America") ~ "United States",
    TRUE ~ Country
  ))


df_pair <- df_tech %>% filter(Country %in% c(countryA, countryB))
ctab <- table(df_pair$Country, df_pair$treatment, useNA = "no")
ctab
prop_table <- prop.table(ctab, margin = 1)
round(prop_table, 3)


chisq_result <- chisq.test(ctab, correct = FALSE)
chisq_result
chisq_result$expected
if(any(chisq_result$expected < 5)){
  fisher_result <- fisher.test(ctab)
  fisher_result
}


library(ggplot2)
plot_df <- as.data.frame(ctab)
colnames(plot_df) <- c("Country", "Treatment", "Count")
plot_df <- plot_df %>%
  group_by(Country) %>%
  mutate(Prop = Count / sum(Count))
ggplot(plot_df, aes(x = Country, y = Prop, fill = Treatment)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(title = paste0("Proportion seeking treatment: ", countryA, " vs ", countryB),
       x = "Country", y = "Proportion (percentage)", fill = "Sought treatment") +
  theme_minimal()


write.csv(as.data.frame(ctab), "contingency_table_country_treatment.csv", row.names = FALSE)
sink("chi_square_results.txt")
print(chisq_result)
if(exists("fisher_result")) print(fisher_result)
sink()
