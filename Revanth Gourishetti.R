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