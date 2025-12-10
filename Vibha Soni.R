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