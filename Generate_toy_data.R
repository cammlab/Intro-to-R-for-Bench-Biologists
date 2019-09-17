# generate toy data from Harish's real data 
library(batman)
luc <- read_csv('data/Luciferase_dataframe.csv')

separate_luc <- luc %>% select(-X1) %>% filter(!L_Concentration == "0") %>% 
  tidyr::extract(col = L_Concentration, into = c("L_Concentration", "L_Units"), regex = "(\\d)([un]M)") %>% 
  tidyr::extract(col = D_Concentration, into = c("D_Concentration", "D_Units"), regex = "(\\d+)([un]M)")

convert_luc <- separate_luc %>% dplyr::mutate_at(vars(ends_with("tration")), as.numeric) %>% 
  dplyr::mutate(TF_booster = to_logical(TF_booster)) %>% mutate_at(vars(c("Condition", "Plate_ID", "Exp_Date")), as.factor) %>% 
  mutate(Signal = sample(Signal))


write_csv(convert_luc, path = "luciferase_toy_data.csv")
write_rds(convert_luc, path = "luciferase_toy_data.rds")
