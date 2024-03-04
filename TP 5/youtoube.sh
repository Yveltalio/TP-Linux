#!/bin/bash
#https://www.youtube.com/watch?v=tZUo4K9yJr4
if [ ! -d "/srv/yt/downloads/" ];
then
echo "folder /srv/yt/downloads/ doesnt exist";
exit
fi  

if [ ! -d "/var/log/yt/" ];
then
echo "folder /var/log/yt/ doesnt exist";
exit
fi  

url="$1"
video_name=$(youtube-dl -e "$url")

if [ -d "/srv/yt/downloads/${video_name}" ];
then
echo "Video already downloaded";
exit
fi  
date=$(date +"%Y/%m/%d %H:%M:%S")
mkdir "/srv/yt/downloads/$video_name"
youtube-dl -o "/srv/yt/downloads/${video_name}/${video_name}.mp4" --format mp4 $url > /dev/null
echo "Video $url was downloaded."
echo "File path : /srv/yt/downloads/$video_name/$video_name.mp4"
echo "["$date"] Video $url was downloaded. File path : /srv/yt/downloads/$video_name/$video_name.mp4" >> /var/log/yt/download.log
mkdir "/srv/yt/downloads/${video_name}/description/"
youtube-dl --get-description $url > "/srv/yt/downloads/${video_name}/description/description"