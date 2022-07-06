# import files to merge
Bt_1 <- read.table("./Gene_lists/P/P_aeruginosa_P14_2.txt", sep = "\t")
Bt_2 <- read.table("./Gene_lists/P/P_aeruginosa_P14_1.txt", sep = "\t")
Bt_3 <- read.table("./Gene_lists/P/P_aeruginosa_P14.txt", sep = "\t")

Bt_temp <- merge(x = Bt_1, y = Bt_2, by = "V1", all.x = TRUE)
Bt_final <- merge(x = Bt_temp, y = Bt_3, by = "V1", all.x = TRUE)

write.table(Bt_final,"./Gene_lists/P/S_marcescens_final.txt", row.names = FALSE)
