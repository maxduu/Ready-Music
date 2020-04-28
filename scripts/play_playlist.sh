#!/bin/bash
# Input: ./play_playlist -s <playlist_name>

# set default value of variable shuffle false
shuffle=false

# get input argument playlist
playlist="$1"

# Change variables based on flag
while getopts 's' flag; do
	case "${flag}" in
		s) shuffle=true 
		   playlist="$2" ;;
	esac
done

# change directory to playlists
cd ~/Desktop/songs/playlists

playlistFile="$playlist.m3u"

# if playlist not existed, echo failure msg and exit
if [ ! -f "$playlistFile" ]; then
	echo "Playlist '$playlist' does not exist!"
	exit 128
fi

# otherwise, if user choose to shuffle, use mplayer to play after shuffling
if [ "$shuffle" = true ]; then
	echo "Shuffling '$playlist'..."
	mplayer -loop 0 -shuffle -playlist $playlistFile

# else, use mplayer to play the songs in playlist in order
else
	echo "Playing '$playlist' in order..."
	mplayer -loop 0 -playlist $playlistFile
fi
