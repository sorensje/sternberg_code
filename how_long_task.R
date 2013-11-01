## trial reader
study_folder <- "/Users/Jim/Desktop/optimize_sarah/code_jim_optimize/"
attempt_folder <- "now_with_prrobe"
attempt_folder <- "meet_joelle_sarah"
setwd(paste(study_folder,attempt_folder,sep="")) # set wd
file_prefix <- "mspois_isi_nobyrun_isibyrun_432"
file_prefix <- "rdux_isi_nobyrun_432"
file_prefix <- "mspois_isibyrun_condnot_isi1_3500_isi2_3500"
file_prefix <- "randunif_change_constraints" #set this to whatever


iteration <- 12
filename <- paste(file_prefix,"_trial_data_",iteration,".csv",sep="")
#   filename<- "StimTimes_mspois_isi_nobyrun_isibyrun_432_15"
trial_file <- read.csv(filename)
total_time <- sum(trial_file[,c("ISI_1","ISI_2","ITI","studytime","cue_time","probe_time")])
total_time/60000

#plot distrns
hist(trial_file$ISI_1,main=file_prefix)
hist(trial_file$ISI_2,main=file_prefix)
hist(trial_file$ITI,main=file_prefix)

for(iter in 1:25){
  filename_prefix <- "randunif_change_constraints" #set this to whatever
  iteration <- iter
  filename <- paste(file_prefix,"_trial_data_",iteration,".csv",sep="")
  trial_file <- read.csv(filename)
  total_time <- sum(trial_file[,c("ISI_1","ISI_2","ITI","studytime","cue_time","probe_time")])
  total_time <-total_time/60000
  cat('\n',filename,'  ',total_time)
  
}


