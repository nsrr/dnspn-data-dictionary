ver="0.1.0.pre"

library(tidyr)
library(dplyr)
data <- read.csv("/VOLUMES/BWH-SLEEPEPI-NSRR-STAGING/20260310-maski-dns/nsrr-prep/DNS_NSRR_Data.csv")
data <- data %>% select(-PSG_SM)
data <- data %>% rename_with(tolower)
data <- data %>%
  mutate(visit = 0) %>%
  relocate(visit, .after = subjectid)
write.csv(data, "/VOLUMES/BWH-SLEEPEPI-NSRR-STAGING/20260310-maski-dns/nsrr-prep/0.1.0.pre/dnspn-dataset.0.1.0.pre.csv", row.names = FALSE, na = '')

# harmonized dataset
harmonized_data <- data[,c("subjectid","visit","age","race","gender")]%>%
  dplyr::mutate(nsrrid=subjectid,
                nsrr_age=age,
                nsrr_race=dplyr::case_when(
                  race==1 ~ "white",
                  race==2 ~ "asian",
                  race==3 ~ "black or african american",
                  race==4 ~ "other",
                  TRUE ~ "not reported"
                ),
                nsrr_sex=dplyr::case_when(
                  gender==1 ~ "male",
                  gender==2 ~ "female",
                  TRUE ~ "not reported"
                ))%>%
  select(nsrrid,visit,nsrr_age,nsrr_race,nsrr_sex)

psg_variables <- data %>%
  select(psgtib, psg_tstmin, psg_waso, psg_se, psg_sol, psg_remlat, n1perc, n2perc, n3perc, remperc, rem_duration, arousalindex, obahi) %>%
  rename(nsrr_tib_f1=psgtib,
         nsrr_tst_f1=psg_tstmin,
         nsrr_waso_f1=psg_waso,
         nsrr_ttleffsp_f1=psg_se,
         nsrr_ttllatsp_f1=psg_sol,
         nsrr_ttlprdsp_s1sr=psg_remlat,
         nsrr_pctdursp_s1=n1perc,
         nsrr_pctdursp_s2=n2perc,
         nsrr_pctdursp_s3=n3perc,
         nsrr_pctdursp_sr=remperc,
         nsrr_ttldursp_sr=rem_duration,
         nsrr_phrnumar_f1=arousalindex,
         nsrr_oahi=obahi
  )

harmonized_data <- bind_cols(harmonized_data, psg_variables)

write.csv(harmonized_data, "/VOLUMES/BWH-SLEEPEPI-NSRR-STAGING/20260310-maski-dns/nsrr-prep/0.1.0.pre/dnspn-harmonized-dataset.0.1.0.pre.csv", row.names = FALSE, na = '')
