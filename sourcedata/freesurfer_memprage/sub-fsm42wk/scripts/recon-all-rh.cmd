

#---------------------------------
# New invocation of recon-all Mon Nov 25 10:07:11 UTC 2024 
#--------------------------------------------
#@# Tessellate rh Mon Nov 25 10:07:19 UTC 2024

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 rh Mon Nov 25 10:07:34 UTC 2024

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 rh Mon Nov 25 10:07:40 UTC 2024

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere rh Mon Nov 25 10:08:08 UTC 2024

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#@# Fix Topology rh Mon Nov 25 10:10:40 UTC 2024

 mris_fix_topology -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 sub-fsm42wk rh 


 mris_euler_number ../surf/rh.orig.premesh 


 mris_remesh --remesh --iters 3 --input /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/surf/rh.orig.premesh --output /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/surf/rh.orig 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm -f ../surf/rh.inflated 

#--------------------------------------------
#@# AutoDetGWStats rh Mon Nov 25 10:14:18 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.rh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/rh.orig.premesh
#--------------------------------------------
#@# WhitePreAparc rh Mon Nov 25 10:14:30 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --wm wm.mgz --threads 8 --invol brain.finalsurfs.mgz --rh --i ../surf/rh.orig --o ../surf/rh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
#--------------------------------------------
#@# CortexLabel rh Mon Nov 25 10:27:59 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 0 ../label/rh.cortex.label
#--------------------------------------------
#@# CortexLabel+HipAmyg rh Mon Nov 25 10:28:51 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 1 ../label/rh.cortex+hipamyg.label
#--------------------------------------------
#@# Smooth2 rh Mon Nov 25 10:29:49 UTC 2024

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 rh Mon Nov 25 10:29:58 UTC 2024

 mris_inflate ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh Mon Nov 25 10:30:43 UTC 2024

 mris_curvature -w -seed 1234 rh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 

#--------------------------------------------
#@# Sphere rh Mon Nov 25 10:32:50 UTC 2024

 mris_sphere -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg rh Mon Nov 25 10:41:22 UTC 2024

 mris_register -curv ../surf/rh.sphere /opt/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg 


 ln -sf rh.sphere.reg rh.fsaverage.sphere.reg 

#--------------------------------------------
#@# Jacobian white rh Mon Nov 25 10:52:18 UTC 2024

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv rh Mon Nov 25 10:52:20 UTC 2024

 mrisp_paint -a 5 /opt/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc rh Mon Nov 25 10:52:23 UTC 2024

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-fsm42wk rh ../surf/rh.sphere.reg /opt/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# WhiteSurfs rh Mon Nov 25 10:52:51 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white.preaparc --o ../surf/rh.white --white --nsmooth 0 --rip-label ../label/rh.cortex.label --rip-bg --rip-surf ../surf/rh.white.preaparc --aparc ../label/rh.aparc.annot
#--------------------------------------------
#@# T1PialSurf rh Mon Nov 25 11:07:51 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 8 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white --o ../surf/rh.pial.T1 --pial --nsmooth 0 --rip-label ../label/rh.cortex+hipamyg.label --pin-medial-wall ../label/rh.cortex.label --aparc ../label/rh.aparc.annot --repulse-surf ../surf/rh.white --white-surf ../surf/rh.white
#@# white curv rh Mon Nov 25 11:21:40 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
#@# white area rh Mon Nov 25 11:21:45 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
#@# pial curv rh Mon Nov 25 11:21:47 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
#@# pial area rh Mon Nov 25 11:21:52 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
#@# thickness rh Mon Nov 25 11:21:55 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
#@# area and vertex vol rh Mon Nov 25 11:23:09 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness

#-----------------------------------------
#@# Curvature Stats rh Mon Nov 25 11:23:13 UTC 2024

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-fsm42wk rh curv sulc 

#-----------------------------------------
#@# Cortical Parc 2 rh Mon Nov 25 11:23:20 UTC 2024

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-fsm42wk rh ../surf/rh.sphere.reg /opt/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh Mon Nov 25 11:23:58 UTC 2024

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-fsm42wk rh ../surf/rh.sphere.reg /opt/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# WM/GM Contrast rh Mon Nov 25 11:24:25 UTC 2024

 pctsurfcon --s sub-fsm42wk --rh-only 



#---------------------------------
# New invocation of recon-all Mon Nov 25 17:36:03 UTC 2024 
#--------------------------------------------
#@# AutoDetGWStats rh Mon Nov 25 17:36:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.rh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/rh.orig.premesh
  Update not needed
#--------------------------------------------
#@# WhitePreAparc rh Mon Nov 25 17:36:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --wm wm.mgz --threads 8 --invol brain.finalsurfs.mgz --rh --i ../surf/rh.orig --o ../surf/rh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
   Update not needed
#--------------------------------------------
#@# CortexLabel rh Mon Nov 25 17:36:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 0 ../label/rh.cortex.label
   Update not needed
#--------------------------------------------
#@# CortexLabel+HipAmyg rh Mon Nov 25 17:36:06 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 1 ../label/rh.cortex+hipamyg.label
   Update not needed
#@# white curv rh Mon Nov 25 17:36:07 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
   Update not needed
#@# white area rh Mon Nov 25 17:36:07 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
   Update not needed
#@# pial curv rh Mon Nov 25 17:36:07 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
   Update not needed
#@# pial area rh Mon Nov 25 17:36:07 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
   Update not needed
#@# thickness rh Mon Nov 25 17:36:07 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed
#@# area and vertex vol rh Mon Nov 25 17:36:07 UTC 2024
cd /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/sub-fsm42wk/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
   Update not needed
#-----------------------------------------
#@# Parcellation Stats rh Mon Nov 25 17:36:07 UTC 2024

 mris_anatomical_stats -th3 -mgz -noglobal -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-fsm42wk rh white 


 mris_anatomical_stats -th3 -mgz -noglobal -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-fsm42wk rh pial 

#-----------------------------------------
#@# Parcellation Stats 2 rh Mon Nov 25 17:37:04 UTC 2024

 mris_anatomical_stats -th3 -mgz -noglobal -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-fsm42wk rh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh Mon Nov 25 17:37:36 UTC 2024

 mris_anatomical_stats -th3 -mgz -noglobal -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-fsm42wk rh white 

#--------------------------------------------
#@# BA_exvivo Labels rh Mon Nov 25 17:38:06 UTC 2024

 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-fsm42wk --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.FG1.mpm.vpnl.label --trgsubject sub-fsm42wk --trglabel ./rh.FG1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.FG2.mpm.vpnl.label --trgsubject sub-fsm42wk --trglabel ./rh.FG2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.FG3.mpm.vpnl.label --trgsubject sub-fsm42wk --trglabel ./rh.FG3.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.FG4.mpm.vpnl.label --trgsubject sub-fsm42wk --trglabel ./rh.FG4.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.hOc1.mpm.vpnl.label --trgsubject sub-fsm42wk --trglabel ./rh.hOc1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.hOc2.mpm.vpnl.label --trgsubject sub-fsm42wk --trglabel ./rh.hOc2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.hOc3v.mpm.vpnl.label --trgsubject sub-fsm42wk --trglabel ./rh.hOc3v.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.hOc4v.mpm.vpnl.label --trgsubject sub-fsm42wk --trglabel ./rh.hOc4v.mpm.vpnl.label --hemi rh --regmethod surface 


 mris_label2annot --s sub-fsm42wk --ctab /opt/freesurfer/average/colortable_vpnl.txt --hemi rh --a mpm.vpnl --maxstatwinner --noverbose --l rh.FG1.mpm.vpnl.label --l rh.FG2.mpm.vpnl.label --l rh.FG3.mpm.vpnl.label --l rh.FG4.mpm.vpnl.label --l rh.hOc1.mpm.vpnl.label --l rh.hOc2.mpm.vpnl.label --l rh.hOc3v.mpm.vpnl.label --l rh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /scratch/tmp/fs_mp2rage_tests2/sourcedata/freesurfer_memprage/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-fsm42wk --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s sub-fsm42wk --hemi rh --ctab /opt/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.perirhinal_exvivo.label --l rh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-fsm42wk --hemi rh --ctab /opt/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -noglobal -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-fsm42wk rh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -noglobal -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-fsm42wk rh white 

