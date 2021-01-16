#!/bin/bash
# 
# Add videos to playlist, remote server will download and convert videos to mp3 and
# sync them to any chosen cloud storage location as supported by rclone. 
# Seperate lame from wav file chosen for maximum compatability with target mp3 playing devices
# @gsmitheidw
#
# Setup
# _____
# - Requires the following binaries: youtube-dl ffmpeg lame rclone (optional/preconfigured)
# - Amend vairables as required
# - Note grabbed.txt will track of which items in a playlist have already been completed
# - Call this script as a scheduled task (crontab -e)
# - Script tested on Linux/Bash
#

# Useful Variables
pathmusic='/mnt/mp3'
# playlist on youtube
pathplaylist=$(dialog --inputbox "Enter Playlist URL" 10 40) 3>&1 1>&2 2>&3 3>&-

pathremote='mp3'


cd $pathmusic
youtube-dl -i --prefer-ffmpeg --extract-audio --audio-format wav -o "%(title)s.%(ext)s" \
	--restrict-filenames --exec 'lame --add-id3v2 --tt {} -b 192 -q 0 {} && rm {}' \
	--download-archive $pathmusic/grabbed.txt $pathplaylist

# Sync local music to cloud storage location (seperately setup with rclone)
rclone sync $pathmusic remote:/$pathremote
