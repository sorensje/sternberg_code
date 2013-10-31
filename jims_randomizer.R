### Jim script
# generate set of orders for Sternberg (to be run via deconvolve)
# for sternberg, with trial structure 
encoding_duration <- 6500
# isi1 <- defined below
cueduration <- 4000
# isi2 <- defined below
probeduration <- 3000
# iti <- defined below

#########
# Setup
study_folder <- "/Users/Jim/Desktop/optimize_sarah/code_jim_optimize/"
setwd(study_folder)
attempt_folder <- "post_meeting"
# dir.create(attempt_folder) #if necessary
setwd(paste(study_folder,attempt_folder,sep="")) # set wd
filename_prefix <- "jims_itirules_notbyrun_allow3" #set this to whatever

conditions <- c("all_neg","mixed_expel_pos","all_pos","mixed_expel_neg")
conditions <- factor(conditions)
n_conds <- length(conditions)
n_trials <- 96
n_runs <- 4
trials_percond <- n_trials/n_conds
trials_percond_per_run <- n_trials/n_runs/n_conds
n_loops <- 5 #terrible name

###### what are ISI functions? ######
# probably the thing we'll want to play with.
# ISI_1_rule <- expression(sample(c(2500,4000,6000),size=trials_percond,replace=TRUE,prob=c(.4,.3,.2))+runif(trials_percond,-500,500))
# ISI_2_rule <- expression(sample(c(2000,4000,6000),size=trials_percond,replace=TRUE,prob=c(.4,.3,.2))+runif(trials_percond,-500,500))
# ITI_rule <- expression(sample(c(2000,4000,6000),size=trials_percond,replace=TRUE,prob=c(.4,.3,.2))+runif(trials_percond,-500,500))

ISI_1_rule <- expression(sample(c(3500,5500,7500),size=trials_percond,replace=TRUE,prob=c(.5,.3,.2))+runif(trials_percond,-500,500))
ISI_2_rule <- expression(sample(c(2500,4500,6500),size=trials_percond,replace=TRUE,prob=c(.5,.3,.2))+runif(trials_percond,-500,500))
ITI_rule <- expression(sample(c(2500,4500,6500),size=trials_percond,replace=TRUE,prob=c(.5,.3,.2))+runif(trials_percond,-500,500))


# ### if use Michael's functions...
# source("~/Desktop/optimize_sarah/code_jim_optimize/expConstrain.R")
# source("~/Desktop/optimize_sarah/code_jim_optimize/randUnifConstrain.R")

# ISI_1_rule <- expression(randUnifConstrain(trials_percond, seq(2000,10000,by=100), 2500)) #slow 
# ISI_2_rule <- randUnifConstrain(trials_percond, seq(2000,10000,by=100), 2500)
# ITI_rule <- randUnifConstrain(trials_percond, seq(2000,10000,by=100), 4000)

# ISI_1_rule <- expression(randUnifConstrain(trials_percond, seq(2000,8000,by=100), 3500)) #slow 
# ISI_2_rule <- expression(randUnifConstrain(trials_percond, seq(2000,6000,by=100), 2500))
# ITI_rule <- expression(randUnifConstrain(trials_percond, seq(2000,6000,by=100), 2500))


########### 
# set up master data frame
############
trial_data_master <- data.frame(trial=1:n_trials,
                         run=rep(1:n_runs,times=1,each=n_trials/n_runs),
                         studytime=rep(encoding_duration,n_trials),
                         cue_time=rep(cueduration,n_trials)
                         )
trial_data_master$cond <- conditions #lazy
trial_data_master$ISI_1 <- 0
trial_data_master$ISI_2 <- 0
trial_data_master$ITI <- 0
trial_data_master$onset_trial_local <- 0 # onsets based on start of run 
trial_data_master$onset_cue_local <- 0 # onsets based on start of run 


#############################################
### iterate through, creating some orders
################################################
for(iter_loop in 1:n_loops){
  ### randomize inner loop 
  trial_data_iteration <- trial_data_master
    ## randomize order of conditions
#     for (iter_run in 1: n_runs){ #necessary to do this to maintain same number of trials in run
      no_crazyrepeats <- FALSE
      while (no_crazyrepeats == FALSE){
        cond <- sample(trial_data_iteration[trial_data_iteration$run==iter_run,'cond'],replace=F)
        cond_plus1 <- Hmisc::Lag(cond, 1)
        cond_plus2 <- Hmisc::Lag(cond, 2)
        threeinarow <- cond == cond_plus1 & cond_plus1 == cond_plus2
        threeinarow[is.na(threeinarow)] <- FALSE
        n_threeinarow <- sum(as.numeric(threeinarow))
        no_crazyrepeats <- n_threeinarow < 4
        trial_data_iteration[trial_data_iteration$run==iter_run,'cond'] <- cond
      }
#     }  # while loop doesn't allow three-peats 
  
  
  #### make ISIs & ITIs (set up to do per condition, if we decide to do that)
   for(iter_cond in conditions){
     trial_data_iteration[trial_data_iteration$cond==iter_cond,'ISI_1'] <-eval(ISI_1_rule) 
     trial_data_iteration[trial_data_iteration$cond==iter_cond,'ISI_2'] <-eval(ISI_2_rule) 
     trial_data_iteration[trial_data_iteration$cond==iter_cond,'ITI'] <-eval(ITI_rule) 
   }
  
  ## calculate trial onsets
  trial_data_iteration$trial_duration <- rowSums(trial_data_iteration[,c("studytime", "cue_time","ISI_1","ISI_2","ITI")])
  trial_data_iteration$b4cue_duration <- rowSums(trial_data_iteration[,c("studytime","ISI_1")])
  
  for (iter_run in 1: n_runs){ 
   runtrials <- trial_data_iteration[trial_data_iteration$run==iter_run,'trial']
   first_trial <- min(runtrials)
   trial_data_iteration[trial_data_iteration$trial==first_trial,'onset_trial_local'] <- 0 #technically not necessary
   for(iter_trial in runtrials[-1]){ # -1 bc don't want to do first trial?
     # trial onset
     trial_data_iteration[trial_data_iteration$trial==(iter_trial),'onset_trial_local'] <- 
       trial_data_iteration[trial_data_iteration$trial==(iter_trial-1),'trial_duration'] +
       trial_data_iteration[trial_data_iteration$trial==(iter_trial-1),'onset_trial_local']
   }
   for(iter_trial in runtrials){ 
     # cue onset
     trial_data_iteration[trial_data_iteration$trial==(iter_trial),'onset_cue_local'] <- 
       trial_data_iteration[trial_data_iteration$trial==(iter_trial),'onset_trial_local'] +
       trial_data_iteration[trial_data_iteration$trial==(iter_trial),'b4cue_duration'] 
   }
  }
  
  ## global onsets 
  trial_data_iteration$global_onset <- trial_data_iteration$onset_trial_local #just to initialize
  for( trial_iter in 2:n_trials){
    trial_data_iteration$global_onset[trial_iter] <- trial_data_iteration$global_onset[trial_iter-1]+ trial_data_iteration$trial_duration[trial_iter-1]
  }
  
  ## get duration of blocks (not necessary anymore?)
  max_time_run <- rep(0,n_runs)
  block_onset <- rep(0,n_runs)
  for (iter_run in 1: n_runs){
    runtrials <- trial_data_iteration[trial_data_iteration$run==iter_run,'trial']
    last_trial <- max(runtrials)
    first_trial<- min(runtrials)
    max_time_run[iter_run] <- trial_data_iteration[trial_data_iteration$trial==last_trial,'onset_trial_local']+ trial_data_iteration[trial_data_iteration$trial==last_trial,'trial_duration']
    block_onset[iter_run] <- trial_data_iteration[trial_data_iteration$trial==first_trial,'global_onset']
  }
  
  # create vectors for later getting total time/TR info
  max_time_run <- round(max_time_run/1000,0)
  max_time_run <- max_time_run+max_time_run%%2 #round to 2 sec
  total_time <- sum(max_time_run)
  total_time <- total_time/2 # to get time points (TRs)
  block_onset <- round(block_onset/1000,0)
  block_onset <- block_onset+block_onset%%2 #round to 2 sec
  block_onset_TR <- block_onset/2
  
  trial_data_iteration$onset_trial_local_secs <- round(trial_data_iteration$onset_trial_local/1000,1)
  trial_data_iteration$onset_cue_local_secs <- round(trial_data_iteration$onset_cue_local/1000,1)
  
  # write stim file   
  for(iter_cond in conditions){
    filename_cue <- paste(filename_prefix,"_",iter_cond,"_cueonset_iter_",iter_loop,".txt",sep="")     
    vanilla_data_matrix <- matrix(trial_data_iteration[trial_data_iteration$cond==iter_cond,'onset_cue_local_secs'],byrow=TRUE,nrow= n_runs)
    write.table(vanilla_data_matrix,filename_cue, row.names=FALSE, col.names = FALSE)
  }
  
  #write run lengths
  filename_runlengths <-  paste(filename_prefix,"_runlengths_iter_",iter_loop,".txt",sep="")
  filename_run_TRstart <-  paste(filename_prefix,"_run_TRstart_iter_",iter_loop,".txt",sep="")
  filename_totalengths <-  paste(filename_prefix,"_totallengths_iter_",iter_loop,".txt",sep="")
  
  write.table(t(max_time_run),filename_runlengths, row.names=FALSE, col.names = FALSE)
  write.table(t(block_onset_TR),filename_run_TRstart, row.names=FALSE, col.names = FALSE)
  write.table(total_time,filename_totalengths, row.names=FALSE, col.names = FALSE)
  
  #write trial file
  filename_trial <- paste(filename_prefix,"_trial_data_",iter_loop,".csv",sep="")
  write.csv(trial_data_iteration,filename_trial,row.names=FALSE)
}




