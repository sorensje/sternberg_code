###  write timing files for FSL

## where do the files live? 
study_folder <- "/Users/Jim/Dropbox/sternberg_training_study/sternberg_code/"
attempt_folder <- "should_break"
# attempt_folder <- "meet_joelle_sarah"
setwd(paste(study_folder,attempt_folder,sep=""))
file_prefixes <- dir(pattern="*.csv")
file_prefixes <-grep("_1.csv",file_prefixes,value=T) #get just one each
file_prefixes <-unlist(strsplit(file_prefixes,"_trial_data_1.csv"))
print(file_prefixes)
file_prefix <- file_prefixes[1]
# file_prefix <- "gen_with_poisson"

## set up shit 
conditions <- c("all_neg","mixed_expel_pos","all_pos","mixed_expel_neg")
conditions <- factor(conditions)
n_conds <- length(conditions)
n_trials <- 80
n_runs <- 4
trials_percond <- n_trials/n_conds
trials_percond_per_run <- n_trials/n_runs/n_conds
n_loops <- 50 #terrible name

encoding_duration <- 6500
# isi1 <- defined below
cueduration <- 4000
# isi2 <- defined below
probeduration <- 3000
# iti <- defined below
iter_loop=1
rm(iter_loop)

# dir.create("FSL_timing")

for(iter_loop in 1:n_loops){  
  setwd(paste(study_folder,attempt_folder,sep=""))
  filename_iter <- paste(file_prefix,"_trial_data_",iter_loop,".csv",sep="")
  trial_data_iteration <- read.csv(filename_iter)
  trial_data_iteration$global_onset_cue <- trial_data_iteration$global_onset+trial_data_iteration$b4cue_duration
  
  setwd(paste(study_folder,attempt_folder,"/FSL_timing",sep=""))
  #write FSL CUE
  for(iter_cond in conditions){
#     iter_cond=conditions[1]
    onsets <- trial_data_iteration[trial_data_iteration$cond==iter_cond,'global_onset_cue']
    onsets <- round(onsets/1000,0)
    duration <- round(cueduration/1000,0)
    vanilla_data_matrix <- cbind(onsets,cueduration,1)
    filename_cue<- paste(file_prefix,"_",iter_cond,"_cue_onset_fsl_",iter_loop,".txt",sep="")     
    write.table(vanilla_data_matrix,filename_cue, row.names=FALSE, col.names = FALSE,sep='\t\t')
  }  
  
  #write FSL encode
  for(iter_cond in conditions){
    #     iter_cond=conditions[1]
    onsets <- trial_data_iteration[trial_data_iteration$cond==iter_cond,'global_onset']
    onsets <- round(onsets/1000,0)
    duration <- round(encoding_duration/1000,0)
    vanilla_data_matrix <- cbind(onsets,cueduration,1)
    filename_encode<- paste(file_prefix,"_",iter_cond,"_encode_onset_fsl_",iter_loop,".txt",sep="")     
    write.table(vanilla_data_matrix,filename_encode, row.names=FALSE, col.names = FALSE,sep='\t\t')
  }  
}