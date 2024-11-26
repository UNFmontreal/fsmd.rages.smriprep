

#---------------------------------
# New invocation of recon-all Sun Nov 24 05:36:36 UTC 2024 

 mri_convert /scratch/tmp/fs_mp2rage_tests2/work/fmriprep_24_1_wf/sub_fsm64ps_wf/anat_fit_wf/anat_template_wf/denoise/mapflow/_denoise0/sub-fsm64ps_acq-mprageVnav_rec-rms_T1w_noise_corrected.nii.gz /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/orig/001.mgz 

#--------------------------------------------
#@# MotionCor Sun Nov 24 05:36:50 UTC 2024

 cp /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/orig/001.mgz /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/rawavg.mgz 


 mri_info /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/rawavg.mgz 


 mri_convert /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/rawavg.mgz /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/transforms/talairach.xfm /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/orig.mgz /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/orig.mgz 


 mri_info /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Sun Nov 24 05:37:07 UTC 2024

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --ants-n4 --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

lta_convert --src orig.mgz --trg /opt/freesurfer/average/mni305.cor.mgz --inxfm transforms/talairach.xfm --outlta transforms/talairach.xfm.lta --subject fsaverage --ltavox2vox
#--------------------------------------------
#@# Talairach Failure Detection Sun Nov 24 05:44:57 UTC 2024

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /opt/freesurfer/bin/extract_talairach_avi_QA.awk /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/transforms/talairach_avi.log 


 tal_QC_AZS /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Sun Nov 24 05:44:57 UTC 2024

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 --ants-n4 


 mri_add_xform_to_header -c /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Sun Nov 24 05:52:27 UTC 2024

 mri_normalize -g 1 -seed 1234 -mprage nu.mgz T1.mgz 



#---------------------------------
# New invocation of recon-all Sun Nov 24 08:30:01 UTC 2024 
#-------------------------------------
#@# EM Registration Sun Nov 24 08:30:08 UTC 2024

 mri_em_register -uns 3 -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.lta 



#---------------------------------
# New invocation of recon-all Sun Nov 24 16:12:34 UTC 2024 
#--------------------------------------
#@# CA Normalize Sun Nov 24 16:12:43 UTC 2024

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Sun Nov 24 16:15:24 UTC 2024

 mri_ca_register -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /opt/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Sun Nov 24 18:23:31 UTC 2024

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /opt/freesurfer/average/RB_all_2020-01-02.gca aseg.auto_noCCseg.mgz 

#--------------------------------------
#@# CC Seg Sun Nov 24 19:25:12 UTC 2024

 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/transforms/cc_up.lta sub-fsm64ps 

#--------------------------------------
#@# Merge ASeg Sun Nov 24 19:26:22 UTC 2024

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Sun Nov 24 19:26:22 UTC 2024

 mri_normalize -seed 1234 -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Sun Nov 24 19:31:44 UTC 2024

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Sun Nov 24 19:31:47 UTC 2024

 AntsDenoiseImageFs -i brain.mgz -o antsdn.brain.mgz 


 mri_segment -wsizemm 13 -mprage antsdn.brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Sun Nov 24 19:36:38 UTC 2024

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.presurf.mgz -ctab /opt/freesurfer/SubCorticalMassLUT.txt wm.mgz filled.mgz 

 cp filled.mgz filled.auto.mgz


#---------------------------------
# New invocation of recon-all Mon Nov 25 12:08:15 UTC 2024 
#@# white curv lh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
   Update not needed
#@# white area lh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
   Update not needed
#@# pial curv lh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
   Update not needed
#@# pial area lh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
   Update not needed
#@# thickness lh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# area and vertex vol lh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# white curv rh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
   Update not needed
#@# white area rh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
   Update not needed
#@# pial curv rh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
   Update not needed
#@# pial area rh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
   Update not needed
#@# thickness rh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed
#@# area and vertex vol rh Mon Nov 25 12:08:22 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed
#--------------------------------------------
#@# Cortical ribbon mask Mon Nov 25 12:08:22 UTC 2024

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-fsm64ps 



#---------------------------------
# New invocation of recon-all Mon Nov 25 17:53:01 UTC 2024 
#--------------------------------------------
#@# WhiteSurfs lh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white.preaparc --o ../surf/lh.white --white --nsmooth 0 --rip-label ../label/lh.cortex.label --rip-bg --rip-surf ../surf/lh.white.preaparc --aparc ../label/lh.aparc.annot
   Update not needed
#--------------------------------------------
#@# WhiteSurfs rh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white.preaparc --o ../surf/rh.white --white --nsmooth 0 --rip-label ../label/rh.cortex.label --rip-bg --rip-surf ../surf/rh.white.preaparc --aparc ../label/rh.aparc.annot
   Update not needed
#@# white curv lh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
   Update not needed
#@# white area lh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
   Update not needed
#@# pial curv lh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
   Update not needed
#@# pial area lh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
   Update not needed
#@# thickness lh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# area and vertex vol lh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
   Update not needed
#@# white curv rh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
   Update not needed
#@# white area rh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
   Update not needed
#@# pial curv rh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
   Update not needed
#@# pial area rh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
   Update not needed
#@# thickness rh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed
#@# area and vertex vol rh Mon Nov 25 17:53:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed

#-----------------------------------------
#@# Curvature Stats lh Mon Nov 25 17:53:06 UTC 2024

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-fsm64ps lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh Mon Nov 25 17:53:11 UTC 2024

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-fsm64ps rh curv sulc 

#-----------------------------------------
#@# Relabel Hypointensities Mon Nov 25 17:53:15 UTC 2024

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# APas-to-ASeg Mon Nov 25 17:53:44 UTC 2024

 mri_surf2volseg --o aseg.mgz --i aseg.presurf.hypos.mgz --fix-presurf-with-ribbon /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/mri/ribbon.mgz --threads 8 --lh-cortex-mask /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/lh.cortex.label --lh-white /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/lh.white --lh-pial /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/lh.pial --rh-cortex-mask /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/rh.cortex.label --rh-white /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/rh.white --rh-pial /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/rh.pial 


 mri_brainvol_stats sub-fsm64ps 

#-----------------------------------------
#@# AParc-to-ASeg aparc Mon Nov 25 17:54:00 UTC 2024

 mri_surf2volseg --o aparc+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/lh.aparc.annot 1000 --lh-cortex-mask /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/lh.cortex.label --lh-white /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/lh.white --lh-pial /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/lh.pial --rh-annot /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/rh.aparc.annot 2000 --rh-cortex-mask /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/rh.cortex.label --rh-white /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/rh.white --rh-pial /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.a2009s Mon Nov 25 17:54:55 UTC 2024

 mri_surf2volseg --o aparc.a2009s+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/lh.aparc.a2009s.annot 11100 --lh-cortex-mask /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/lh.cortex.label --lh-white /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/lh.white --lh-pial /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/lh.pial --rh-annot /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/rh.aparc.a2009s.annot 12100 --rh-cortex-mask /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/rh.cortex.label --rh-white /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/rh.white --rh-pial /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.DKTatlas Mon Nov 25 17:55:54 UTC 2024

 mri_surf2volseg --o aparc.DKTatlas+aseg.mgz --label-cortex --i aseg.mgz --threads 8 --lh-annot /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/lh.aparc.DKTatlas.annot 1000 --lh-cortex-mask /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/lh.cortex.label --lh-white /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/lh.white --lh-pial /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/lh.pial --rh-annot /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/rh.aparc.DKTatlas.annot 2000 --rh-cortex-mask /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/rh.cortex.label --rh-white /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/rh.white --rh-pial /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/rh.pial 

#-----------------------------------------
#@# WMParc Mon Nov 25 17:56:55 UTC 2024

 mri_surf2volseg --o wmparc.mgz --label-wm --i aparc+aseg.mgz --threads 8 --lh-annot /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/lh.aparc.annot 3000 --lh-cortex-mask /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/lh.cortex.label --lh-white /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/lh.white --lh-pial /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/lh.pial --rh-annot /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/rh.aparc.annot 4000 --rh-cortex-mask /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/label/rh.cortex.label --rh-white /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/rh.white --rh-pial /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm64ps/surf/rh.pial 


 mri_segstats --seed 1234 --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-fsm64ps --surf-wm-vol --ctab /opt/freesurfer/WMParcStatsLUT.txt --etiv 

#--------------------------------------------
#@# ASeg Stats Mon Nov 25 18:02:41 UTC 2024

 mri_segstats --seed 1234 --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /opt/freesurfer/ASegStatsLUT.txt --subject sub-fsm64ps 

