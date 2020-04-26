#!/bin/bash

# Create directory to store mp3s
mkdir -p ~/Desktop/songs
cd ~/Desktop/songs

touch recommendations.txt

# Create url from search query
query="$1"
numArgs=$#
args=("$@")
for (( i=1; i<numArgs; i++ ))
do
	query="$query+${args[i]}"
done
query=${query//-}
echo $query
url="https://youtube.com/results?search_query=$query"
echo "$url"

wget -O "htmltemp" $url

# Scrape html for 6 urls (generally corresponds to 3 video results)
watchPattern="/watch\\?v=[a-zA-Z0-9_-]+"
mapfile -t arr < <(grep -E -m 6 -o "$watchPattern" "htmltemp")

arrLength=${#arr[@]}
for (( i=0; i<arrLength; i+=2 ))
do
	end=${arr[i]}
	url="https://youtube.com$end"
	songName=$(youtube-dl --get-filename -o "%(title)s" $url)
	if grep -q "$songName" "recommendations.txt"; then
		echo "$songName already in recommendation list" # Prevent duplicate recommendations
		continue
	fi
	mp3Name="$songName.mp3"
	if [[ -f "$mp3Name" ]]; then
		echo "$songName already downloaded, won't be recommended" # Prevent recommending songs that user already knows
		continue
	fi
	echo "\"$songName\"" >> recommendations.txt
done

rm htmltemp










