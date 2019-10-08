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



## generate fake matrix 

set.seed(1234)
rand_mat <- replicate(10, rnorm(20, mean = 15, sd = 5))

pheatmap::pheatmap(rand_mat)



## use real rna data from Kian's data - to deidentify

rna <-  read_tsv("exprs.eset.mRNA.unique.txt")
rna_map <- rna %>% column_to_rownames("gene_name")
rna_map_abrv <- rna_map[ ,seq(from = 1, to = ncol(rna_map), by = 2)] %>% head(150)
colnames(rna_map_abrv) <- c("Res-1", "Res-2", "Res-3", "Res-4", "Res-5", "Res-6", "Res-6", "Res-7", 
                            "Res-8", "Res-9", "Res-10", "Res-11")
pheatmap::pheatmap(rna_map_abrv, scale = "row",
                   cluster_rows = TRUE, 
                   cluster_cols = FALSE, 
                   show_rownames = FALSE, border_color = NA)

rna_map_exp <- rna_map_abrv %>% rownames_to_column(var = "gene_names") %>% mutate(gene_names = sample(gene_names))
write_csv(rna_map_exp, "Processed_data/rna_matrix.csv", col_names = TRUE)


