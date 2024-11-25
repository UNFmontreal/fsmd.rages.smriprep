

#---------------------------------
# New invocation of recon-all Sat Nov 23 14:53:55 UTC 2024 

 mri_convert /tmp/fmriprep_24_1_wf/sub_fsm11ni_wf/anat_fit_wf/anat_template_wf/denoise/mapflow/_denoise0/sub-fsm11ni_acq-mp2rage_T1w_noise_corrected.nii.gz /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/orig/001.mgz 

#--------------------------------------------
#@# MotionCor Sat Nov 23 14:54:10 UTC 2024

 cp /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/orig/001.mgz /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/rawavg.mgz 


 mri_info /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/rawavg.mgz 


 mri_convert /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/rawavg.mgz /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/transforms/talairach.xfm /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/orig.mgz /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/orig.mgz 


 mri_info /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Sat Nov 23 14:54:24 UTC 2024

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --ants-n4 --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

lta_convert --src orig.mgz --trg /opt/freesurfer/average/mni305.cor.mgz --inxfm transforms/talairach.xfm --outlta transforms/talairach.xfm.lta --subject fsaverage --ltavox2vox
#--------------------------------------------
#@# Talairach Failure Detection Sat Nov 23 15:01:33 UTC 2024

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /opt/freesurfer/bin/extract_talairach_avi_QA.awk /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/transforms/talairach_avi.log 


 tal_QC_AZS /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Sat Nov 23 15:01:33 UTC 2024

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 --ants-n4 


 mri_add_xform_to_header -c /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Sat Nov 23 15:08:34 UTC 2024

 mri_normalize -g 1 -seed 1234 -mprage nu.mgz T1.mgz 



#---------------------------------
# New invocation of recon-all Sat Nov 23 17:48:45 UTC 2024 
#-------------------------------------
#@# EM Registration Sat Nov 23 17:48:47 UTC 2024

 mri_em_register -uns 3 -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.lta 



#---------------------------------
# New invocation of recon-all Sat Nov 23 18:12:35 UTC 2024 
#--------------------------------------
#@# CA Normalize Sat Nov 23 18:12:37 UTC 2024

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Sat Nov 23 18:15:02 UTC 2024

 mri_ca_register -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /opt/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Sat Nov 23 20:26:56 UTC 2024

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /opt/freesurfer/average/RB_all_2020-01-02.gca aseg.auto_noCCseg.mgz 

#--------------------------------------
#@# CC Seg Sat Nov 23 21:20:23 UTC 2024

 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/transforms/cc_up.lta sub-fsm11ni 

#--------------------------------------
#@# Merge ASeg Sat Nov 23 21:21:27 UTC 2024

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Sat Nov 23 21:21:27 UTC 2024

 mri_normalize -seed 1234 -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Sat Nov 23 21:26:29 UTC 2024

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Sat Nov 23 21:26:31 UTC 2024

 AntsDenoiseImageFs -i brain.mgz -o antsdn.brain.mgz 


 mri_segment -wsizemm 13 -mprage antsdn.brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Sat Nov 23 21:31:14 UTC 2024

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.presurf.mgz -ctab /opt/freesurfer/SubCorticalMassLUT.txt wm.mgz filled.mgz 

 cp filled.mgz filled.auto.mgz


#---------------------------------
# New invocation of recon-all Sun Nov 24 12:17:58 UTC 2024 
#@# white curv lh Sun Nov 24 12:18:07 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
   Update not needed
#@# white area lh Sun Nov 24 12:18:07 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
   Update not needed
#@# pial curv lh Sun Nov 24 12:18:07 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
   Update not needed
#@# pial area lh Sun Nov 24 12:18:07 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
   Update not needed
#@# thickness lh Sun Nov 24 12:18:08 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# area and vertex vol lh Sun Nov 24 12:18:08 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# white curv rh Sun Nov 24 12:18:08 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
   Update not needed
#@# white area rh Sun Nov 24 12:18:08 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
   Update not needed
#@# pial curv rh Sun Nov 24 12:18:08 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
   Update not needed
#@# pial area rh Sun Nov 24 12:18:08 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
   Update not needed
#@# thickness rh Sun Nov 24 12:18:08 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed
#@# area and vertex vol rh Sun Nov 24 12:18:08 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed
#--------------------------------------------
#@# Cortical ribbon mask Sun Nov 24 12:18:08 UTC 2024

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-fsm11ni 



#---------------------------------
# New invocation of recon-all Sun Nov 24 19:29:04 UTC 2024 
#--------------------------------------------
#@# WhiteSurfs lh Sun Nov 24 19:29:15 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white.preaparc --o ../surf/lh.white --white --nsmooth 0 --rip-label ../label/lh.cortex.label --rip-bg --rip-surf ../surf/lh.white.preaparc --aparc ../label/lh.aparc.annot
   Update not needed
#--------------------------------------------
#@# WhiteSurfs rh Sun Nov 24 19:29:15 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white.preaparc --o ../surf/rh.white --white --nsmooth 0 --rip-label ../label/rh.cortex.label --rip-bg --rip-surf ../surf/rh.white.preaparc --aparc ../label/rh.aparc.annot
   Update not needed
#@# white curv lh Sun Nov 24 19:29:15 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
   Update not needed
#@# white area lh Sun Nov 24 19:29:15 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
   Update not needed
#@# pial curv lh Sun Nov 24 19:29:15 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
   Update not needed
#@# pial area lh Sun Nov 24 19:29:15 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
   Update not needed
#@# thickness lh Sun Nov 24 19:29:15 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# area and vertex vol lh Sun Nov 24 19:29:15 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# white curv rh Sun Nov 24 19:29:15 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
   Update not needed
#@# white area rh Sun Nov 24 19:29:15 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
   Update not needed
#@# pial curv rh Sun Nov 24 19:29:15 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
   Update not needed
#@# pial area rh Sun Nov 24 19:29:16 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
   Update not needed
#@# thickness rh Sun Nov 24 19:29:16 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed
#@# area and vertex vol rh Sun Nov 24 19:29:16 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed

#-----------------------------------------
#@# Curvature Stats lh Sun Nov 24 19:29:16 UTC 2024

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-fsm11ni lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh Sun Nov 24 19:29:22 UTC 2024

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-fsm11ni rh curv sulc 

#-----------------------------------------
#@# Relabel Hypointensities Sun Nov 24 19:29:27 UTC 2024

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# APas-to-ASeg Sun Nov 24 19:30:01 UTC 2024

 mri_surf2volseg --o aseg.mgz --i aseg.presurf.hypos.mgz --fix-presurf-with-ribbon /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/mri/ribbon.mgz --threads 8 --lh-cortex-mask /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/lh.cortex.label --lh-white /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/lh.white --lh-pial /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/lh.pial --rh-cortex-mask /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/rh.cortex.label --rh-white /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/rh.white --rh-pial /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/rh.pial 


 mri_brainvol_stats sub-fsm11ni 

#-----------------------------------------
#@# AParc-to-ASeg aparc Sun Nov 24 19:30:23 UTC 2024

 mri_surf2volseg --o aparc+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/lh.aparc.annot 1000 --lh-cortex-mask /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/lh.cortex.label --lh-white /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/lh.white --lh-pial /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/lh.pial --rh-annot /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/rh.aparc.annot 2000 --rh-cortex-mask /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/rh.cortex.label --rh-white /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/rh.white --rh-pial /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.a2009s Sun Nov 24 19:31:26 UTC 2024

 mri_surf2volseg --o aparc.a2009s+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/lh.aparc.a2009s.annot 11100 --lh-cortex-mask /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/lh.cortex.label --lh-white /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/lh.white --lh-pial /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/lh.pial --rh-annot /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/rh.aparc.a2009s.annot 12100 --rh-cortex-mask /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/rh.cortex.label --rh-white /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/rh.white --rh-pial /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.DKTatlas Sun Nov 24 19:32:28 UTC 2024

 mri_surf2volseg --o aparc.DKTatlas+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/lh.aparc.DKTatlas.annot 1000 --lh-cortex-mask /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/lh.cortex.label --lh-white /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/lh.white --lh-pial /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/lh.pial --rh-annot /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/rh.aparc.DKTatlas.annot 2000 --rh-cortex-mask /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/rh.cortex.label --rh-white /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/rh.white --rh-pial /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/rh.pial 

#-----------------------------------------
#@# WMParc Sun Nov 24 19:33:31 UTC 2024

 mri_surf2volseg --o wmparc.mgz --label-wm --i aparc+aseg.mgz --threads 8 --lh-annot /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/lh.aparc.annot 3000 --lh-cortex-mask /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/lh.cortex.label --lh-white /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/lh.white --lh-pial /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/lh.pial --rh-annot /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/rh.aparc.annot 4000 --rh-cortex-mask /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/label/rh.cortex.label --rh-white /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/rh.white --rh-pial /scratch/tmp/fs_mp2rage_tests/sourcedata/freesurfer_mp2rage/sub-fsm11ni/surf/rh.pial 


 mri_segstats --seed 1234 --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-fsm11ni --surf-wm-vol --ctab /opt/freesurfer/WMParcStatsLUT.txt --etiv 

#--------------------------------------------
#@# ASeg Stats Sun Nov 24 19:39:23 UTC 2024

 mri_segstats --seed 1234 --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /opt/freesurfer/ASegStatsLUT.txt --subject sub-fsm11ni 

