#!/bin/bash

#This runs 3dDeconvolve with no data (hence no input data and no motion regressors)

#User defined variables
#Note attempt_folder is subdirectory name where files from R script are stored
# prefix is prefix for R files 

rootdir="/Users/Jim/Dropbox/sternberg_training_study/sternberg_code/"
attempt_folder="meet_joelle_sarah"
prefix="mspois_isibyrun_condnot_isi1_3500_isi2_3500"


#Turn on gzip of BRIK files necessary?
export AFNI_AUTOGZIP=YES
export AFNI_COMPRESSOR=GZIP

cd ${rootdir}
cd ${attempt_folder}

for counter in {1..25}; do
	
	echo ${counter}
	echo ${counter}
	echo ${counter}
	echo ${counter}
	
	total_time=$(cat ${prefix}_totallengths_iter_${counter}.txt)
	runlengths=$(cat ${p	refix}_runlengths_iter_${counter}.txt)
	tr_start=$(cat ${prefix}_runlengths_iter_${counter}.txt)

	3dDeconvolve \
	-nodata ${total_time} 2 \
    -concat  ${prefix}'_run_TRstart_iter_'${counter}'.txt'\
	-polort A \
	-local_times\
	-num_stimts 8 \
	-stim_times 1 ${prefix}'_all_neg_cueonset_iter_'${counter}'.txt' 'GAM' \
	-stim_label 1 All_neg_cue \
	-stim_times 2 ${prefix}'_mixed_expel_pos_cueonset_iter_'${counter}'.txt' 'GAM' \
	-stim_label 2 Mix_Ex_P_cue \
	-stim_times 3 ${prefix}'_all_pos_cueonset_iter_'${counter}'.txt' 'GAM' \
	-stim_label 3 All_pos_cue \
	-stim_times 4 ${prefix}'_mixed_expel_neg_cueonset_iter_'${counter}'.txt' 'GAM' \
	-stim_label 4 Mix_Ex_N_cue \
	-stim_times 5 ${prefix}'_all_neg_encodeonset_iter_'${counter}'.txt' 'GAM' \
	-stim_label 5 All_neg_enc \
	-stim_times 6 ${prefix}'_mixed_expel_pos_encodeonset_iter_'${counter}'.txt' 'GAM' \
	-stim_label 6 Mix_Ex_P_enc \
	-stim_times 7 ${prefix}'_all_pos_encodeonset_iter_'${counter}'.txt' 'GAM' \
	-stim_label 7 All_pos_enc \
	-stim_times 8 ${prefix}'_mixed_expel_neg_encodeonset_iter_'${counter}'.txt' 'GAM' \
	-stim_label 8 Mix_Ex_N_enc \
	-num_glt 4         \
	-gltsym 'SYM: All_neg_cue -All_neg_enc' -glt_label 1 neg     \
	-gltsym 'SYM: All_pos_cue -All_pos_enc' -glt_label 2 pos       \
	-gltsym 'SYM: Mix_Ex_P_cue -Mix_Ex_P_enc' -glt_label 3 mix_exp_P     \
	-gltsym 'SYM: Mix_Ex_N_cue -Mix_Ex_N_enc' -glt_label 4 mix_exp_N   \
	-x1D 3dD_${prefix}_${counter}.xmat.1D > 3dD_${prefix}_${counter}.txt
	echo ${prefix}'_'${counter} $( tail -1 3dD_${prefix}_${counter}.txt ) >> ITIOptim_3dD_GAM_encVcue${prefix}.txt

done

# 	echo 'StimTimes_'${prefix}'_'${counter} $(cat 3dD_initial_iti_rulez_1.txt |grep General) $( cat 3dD_initial_iti_rulez_1.txt |grep LC ) >> Optimize${prefix}.txt

