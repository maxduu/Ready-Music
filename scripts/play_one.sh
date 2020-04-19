#!/bin/bash
# Input: ./play_one <query1 query2 ...>

# Create url from search query

query="$1"
numArgs=$#
args=("$@")
for (( i=1; i<numArgs; i++ ))
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
echo "Video chosen: $firsturl"


# TO RUN:
# sudo apt install curl
# sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
# sudo chmod a+rx /usr/local/bin/youtube-dl
# may have to do: sudo ln -s /usr/bin/python3 /usr/bin/python

songName=$(youtube-dl --get-filename -o "%(title)s" $firsturl)
mp3Name="$songName.mp3"
if [ ! -f ~/Desktop/songs/"$mp3Name" ]; then
	echo "Downloading mp3 of '$songName'..."
	youtube-dl -x -o "%(title)s.%(ext)s" --audio-format mp3 $firsturl
	mplayer "$mp3Name"
	rm "$mp3Name"
else
	echo "Song already downloaded locally"
	mplayer ~/Desktop/songs/"$mp3Name"
fi


# Delete files after

rm htmltemp
