#!/bin/bash
# Input: ./add_to_playlist.sh <playlist_name> <query1 query2 ...>

# Create directory to store mp3s
mkdir -p ~/Desktop/songs
cd ~/Desktop/songs

# Make new playlists directory
mkdir -p playlists

# Make new playlist file
playlist="$1"
playlistName="$playlist.m3u"
touch "playlists/$playlistName"

# Create url from search query
query="$2"
numArgs=$#
args=("$@")
for (( i=2; i<numArgs; i++ ))
do
	query="$query+${args[i]}"
done
echo "$query"
url="https://youtube.com/results?search_query=$query"

# Store url's html into a temporary file
wget -O "htmltemp" $url

# Scrape html for first video result
watchPattern="/watch\\?v=[a-zA-Z0-9_-]+"
first=$(grep -E -m 1 -o "$watchPattern" "htmltemp")

firsturl="https://youtube.com$first"
echo "Video chosen: '$firsturl'"

# TO RUN:
# sudo apt install curl
# sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
# sudo chmod a+rx /usr/local/bin/youtube-dl
# may have to do: sudo ln -s /usr/bin/python3 /usr/bin/python

songName=$(youtube-dl --get-filename -o "%(title)s" $firsturl)
mp3Name="$songName.mp3"
if [ ! -f "$mp3Name" ]; then
	echo "Downloading mp3 of '$songName'..."
	youtube-dl -x -o "%(title)s.%(ext)s" --audio-format mp3 $firsturl
else
	echo "Song already downloaded locally"
fi

# Add name to playlist
echo "../$mp3Name" >> playlists/$playlistName
echo "Added '$songName' to playlist '$playlist'"
zenity --info --width=150 --height=120 --text "Added '$songName' to playlist '$playlist'!"
rm htmltemp










