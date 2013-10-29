#!/bin/bash

#This runs 3dDeconvolve with no data (hence no input data and no motion regressors)

#User defined variables
#Note attempt_folder is subdirectory name where files from R script are stored
# prefix is prefix for R files 

rootdir="/Users/Jim/Desktop/optimize_sarah/"
attempt_folder="Jim_try1"
prefix="firstpass"



#Turn on gzip of BRIK files necessary?
export AFNI_AUTOGZIP=YES
export AFNI_COMPRESSOR=GZIP

cd ${rootdir}
cd ${attempt_folder}

for counter in {1..5}; do
	
	echo ${counter}
	echo ${counter}
	echo ${counter}
	echo ${counter}
	
	total_time=$(cat ${prefix}_totallengths_iter_${counter}.txt)
	runlengths=$(cat ${prefix}_runlengths_iter_${counter}.txt)
	tr_start=$(cat ${prefix}_runlengths_iter_${counter}.txt)

	3dDeconvolve \
	-nodata ${total_time} 2 \
    -concat  ${prefix}'_run_TRstart_iter_'${counter}'.txt'\
	-polort A \
	-local_times\
	-num_stimts 4 \
	-stim_times 1 ${prefix}'_all_neg_cueonset_iter_'${counter}'.txt' 'CSPLIN(0, 18,4)' \
	-stim_label 1 All_neg \
	-stim_times 2 ${prefix}'_mixed_expel_pos_cueonset_iter_'${counter}'.txt' 'CSPLIN(0, 18,4)' \
	-stim_label 2 Mix_Ex_P \
	-stim_times 3 ${prefix}'_all_pos_cueonset_iter_'${counter}'.txt' 'CSPLIN(0, 18,4)' \
	-stim_label 3 All_pos \
	-stim_times 4 ${prefix}'_mixed_expel_neg_cueonset_iter_'${counter}'.txt' 'CSPLIN(0, 18,4)' \
	-stim_label 4 Mix_Ex_N \
	-num_glt 6                                                       \
	-gltsym 'SYM: All_neg -All_pos' -glt_label 1 neg-pos     \
	-gltsym 'SYM: Mix_Ex_P -Mix_Ex_N' -glt_label 2 mix_neg-pos       \
	-gltsym 'SYM: All_neg -Mix_Ex_P' -glt_label 3 neg-mix_exp_P     \
	-gltsym 'SYM: All_neg -Mix_Ex_N' -glt_label 4 neg-mix_exp_N   \
	-gltsym 'SYM: All_pos -Mix_Ex_P' -glt_label 5 pos-mix_exp_P \
	-gltsym 'SYM: All_pos -Mix_Ex_N' -glt_label 6 pos-mix_exp_N   \
	-x1D 3dD_${prefix}_${counter}.xmat.1D > 3dD_${prefix}_${counter}.txt

	echo 'StimTimes_'${prefix}'_'${counter} $( tail -1 3dD_${prefix}_${counter}.txt ) >> ITIOptim_3dD_${prefix}.txt
	 
done


