#!/bin/sh

# Ubuntu Trusty 16.04
# FFmpeg current release plus git PPA:

# sudo add-apt-repository ppa:mc3man/ffmpeg-test
# sudo apt-get update
# sudo apt-get install ffmpeg-static
# hash -r

# Now run ffmpeg2 (note the "2").

search_dir="/media/timonet/Repositorio/Mula/GOPRO/VueltaAlicante/Videos"

for entry in "$search_dir"/*.MP4
do
  #echo "${entry%/*}"
  #echo "${entry##*/}"
  filedir="${entry%/*}"
  videofile="$filedir/${entry##*/}"
  #echo $videofile
  logvideofile="$filedir/log/${entry##*/}.trf"
  videofileNoExt="$filedir/"$(echo "/$entry" | sed -r "s/.+\/(.+)\..+/\1/")"_stab.mp4"

  echo "Procesando pase 1 para: "${entry##*/}
  ffmpeg2 -i "$videofile" -vf vidstabdetect=stepsize=32:shakiness=10:accuracy=10:result="$logvideofile" -f null - 
  
  echo "Procesando pase 2 para: "${entry##*/}
  ffmpeg2 -i "$videofile" -vf vidstabtransform=input="$logvideofile":zoom=0:smoothing=10,unsharp=5:5:1.0:5:5:1.0 -vcodec libx264 -tune film -acodec copy -preset slow "$videofileNoExt"
  
  ##########################################
  #example to add cropping after the stabilitzation process. Very useful to achieve best quality 
  #if we record in 1440p and we want to get rid of 
  #some fake borders the vidstab plugin generates. (1440-1080)/2 = 240
  #
  #ffmpeg2 -i "$videofile" -vf vidstabtransform=input="$logvideofile":zoom=0:smoothing=10,unsharp=5:5:1.0:5:5:1.0,crop=1920:1080:0:240 -vcodec libx264 -tune film -acodec copy -preset slow "$videofileNoExt"
  ##########################################
  
  ##########################################
  #example to recode un h265
  #
  #ffmpeg2 -i "$videofile" -vf vidstabtransform=input="$logvideofile":zoom=0:smoothing=10,unsharp=5:5:1.0:5:5:1.0 -vcodec libx265 -tune zerolatency -acodec copy -preset fast "$videofileNoExt"
  ##########################################
  

done
