###  write regressors from already generated tiral lists

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

# for(iter_prefixes in 1:length(file_prefixes)){
# file_prefix<-file_prefixes[iter_prefixes]  
  for(iter_loop in 1:n_loops){  
    filename_iter <- paste(file_prefix,"_trial_data_",iter_loop,".csv",sep="")
    trial_data_iteration <- read.csv(filename_iter)
   
    # write stim file   
    for(iter_cond in conditions){
      filename_encode <- paste(file_prefix,"_",iter_cond,"_encodeonset_iter_",iter_loop,".txt",sep="")     
      vanilla_data_matrix <- matrix(trial_data_iteration[trial_data_iteration$cond==iter_cond,'onset_trial_local_secs'],byrow=TRUE,nrow= n_runs)
      write.table(vanilla_data_matrix,filename_encode, row.names=FALSE, col.names = FALSE)
      
    }  
    
    # write all encode
    filename_all_encode <- paste(file_prefix,"_all_encodeonset_iter_",iter_loop,".txt",sep="")     
    vanilla_data_matrix <- matrix(trial_data_iteration[,'onset_trial_local_secs'],byrow=TRUE,nrow= n_runs)
    write.table(vanilla_data_matrix,filename_all_encode, row.names=FALSE, col.names = FALSE)
    
    #write all nonencode
    filename_all_cue <- paste(file_prefix,"_all_cueonset_iter_",iter_loop,".txt",sep="")     
    vanilla_data_matrix <- matrix(trial_data_iteration[,'onset_cue_local_secs'],byrow=TRUE,nrow= n_runs)
    write.table(vanilla_data_matrix,filename_all_cue, row.names=FALSE, col.names = FALSE)
    
  }
# }
