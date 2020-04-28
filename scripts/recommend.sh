#!/bin/bash

# Create directory to store mp3s
mkdir -p ~/Desktop/songs
cd ~/Desktop/songs

# create a txt file to store recommended songs later
touch recommendations.txt

# Create url from search query
query="$1"
numArgs=$#
echo $numArgs
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
#mapfile -t arr < <(grep -E -m 6 -o "$watchPattern" "htmltemp")
old=$IFS
IFS=$'\n'
arr=($(grep -E -m 6 -o "$watchPattern" "htmltemp"))
IFS=$old

# iterate over the array to add songs in the recommendations.txt
arrLength=${#arr[@]}
for (( i=0; i<arrLength; i+=2 ))
do

  # get the url and songname
	end=${arr[i]}
	url="https://youtube.com$end"
	songName=$(youtube-dl --get-filename -o "%(title)s" $url)

  # if song already in recommendations.txt, echo msg and continue without recommending
	if grep -q "$songName" "recommendations.txt"; then
		echo "$songName already in recommendation list" # Prevent duplicate recommendations
		continue
	fi

  # if song already in the song library, echo msg and continut without recommending
	mp3Name="$songName.mp3"
	if [[ -f "$mp3Name" ]]; then
		echo "$songName already downloaded, won't be recommended" # Prevent recommending songs that user already knows
		continue
	fi

  # otherwise, add song name to recommendations.txt and recommend to user 
	echo "\"$songName\"" >> recommendations.txt
done

# remove temporary file
rm htmltemp










