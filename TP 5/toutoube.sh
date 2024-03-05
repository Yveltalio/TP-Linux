#!/bin/bash
#04/03/24
#script youtube downloader pour le service

#https://www.youtube.com/watch?v=CGjwqbaJ3xw
#https://www.youtube.com/watch?v=tZUo4K9yJr4

if [ ! -d "/srv/yt/downloads/" ];
then
echo "folder /srv/yt/downloads/ doesnt   exist";
exit
fi  

if [ ! -d "/var/log/yt/" ];
then
echo "folder /var/log/yt/ doesnt exist";
exit
fi

while : 
    do
    url=$(cat "/srv/yt/video")
    chaque_url=$(echo $url | tr -s ' ' | cut -d ' ' -f1)
    if [ ! -z $chaque_url ];
    then
        if [[ ! $chaque_url =~ ^https://www\.youtube\.com/watch\?v=[a-zA-Z0-9]{11}$ ]];
        then
            echo "Not valid url";
            sed -i '1d' "/srv/yt/video"
            continue
        fi
        video_name=$(youtube-dl -e "$chaque_url")
        if [ -d "/srv/yt/downloads/${video_name}" ];
        then
            echo "Video already downloaded";
            sed -i '1d' "/srv/yt/video"
            continue
        fi  
        date=$(date +"%Y/%m/%d %H:%M:%S")
        mkdir "/srv/yt/downloads/$video_name"
        youtube-dl -o "/srv/yt/downloads/${video_name}/${video_name}.mp4" --format mp4 $chaque_url > /dev/null
        echo "Video $chaque_url was downloaded."
        echo "File path : /srv/yt/downloads/$video_name/$video_name.mp4"
        echo "["$date"] Video $chaque_url was downloaded. File path : /srv/yt/downloads/$video_name/$video_name.mp4" >> /var/log/yt/download.log
        mkdir "/srv/yt/downloads/${video_name}/description/"
        youtube-dl --get-description $chaque_url > "/srv/yt/downloads/${video_name}/description/description"
        sed -i '1d' "/srv/yt/video"
    else
    echo "Empty File"
    sleep 10
    fi
done 