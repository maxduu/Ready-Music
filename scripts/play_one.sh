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

echo "Downloading audio of '$songName'..."
youtube-dl -x -o "%(title)s.%(ext)s" $firsturl
toPlay=$(find -name "$songName*" -maxdepth 1)
mplayer "$toPlay"

# Delete files after
rm "$toPlay"
rm htmltemp
