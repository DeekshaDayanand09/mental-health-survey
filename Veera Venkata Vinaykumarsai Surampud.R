chisq_result <- chisq.test(ctab, correct = FALSE)
chisq_result
chisq_result$expected
if(any(chisq_result$expected < 5)){
  fisher_result <- fisher.test(ctab)
  fisher_result
}