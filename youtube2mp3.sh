#!/bin/bash 

# A barebones script to extract the audio track from a YouTube video 

address=$1;
regex='v=(.*)';
if [[ $address =~ $regex ]]; then 
    video_id=${BASH_REMATCH[1]};
    video_id=$(echo $video_id | cut -d'&' -f1);
    video_title="$(youtube-dl --get-title $address)"; 
    youtube-dl $address;
    # TODO: find a better way to get appropriate video file extension
    ext=$(find * -maxdepth 0 -name "*.mp4" -o -name "*.mkv" | tail -n 1 | awk -F . '{if (NF>1) {print $NF}}')
    # convert video file to .wav format for lame
    ffmpeg -hide_banner -loglevel panic -i "$video_title-$video_id".$ext "$video_title".wav; 
    # extract audio from .wav video file, save as .mp3 in ~/Downloads
    lame "$video_title".wav $HOME/Downloads/"$video_title".mp3;
    rm "$video_title-$video_id".$ext "$video_title".wav;
else 
    echo "Sorry but the system encountered a problem." 
fi
