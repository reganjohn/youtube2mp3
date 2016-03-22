#!/bin/bash 

# A very simple Bash script to download a YouTube video 
# and extract the music file from it. 

address=$1;
regex='v=(.*)';
if [[ $address =~ $regex ]]; then 
    video_id=${BASH_REMATCH[1]};
    video_id=$(echo $video_id | cut -d'&' -f1);
    video_title="$(youtube-dl --get-title $address)"; 
    youtube-dl $address;
    ext=$(find * -maxdepth 0 -name "*.mp4" -o -name "*.mkv" | tail -n 1 | awk -F . '{if (NF>1) {print $NF}}')
    ffmpeg -hide_banner -loglevel panic -i "$video_title-$video_id".$ext "$video_title".wav; 
    lame "$video_title".wav $HOME/Downloads/"$video_title".mp3;
    rm "$video_title-$video_id".$ext "$video_title".wav;
else 
    echo "Sorry but the system encountered a problem." 
fi
