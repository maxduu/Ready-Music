#!/bin/bash
# Input: ./play_playlist -s <playlist_name>

shuffle=false
playlist="$1"

# Change variables based on flag
while getopts 's' flag; do
	case "${flag}" in
		s) shuffle=true 
		   playlist="$2" ;;
	esac
done

cd ~/Desktop/songs/playlists

playlistFile="$playlist.m3u"

if [ ! -f "$playlistFile" ]; then
	echo "Playlist '$playlist' does not exist!"
	exit 128
fi

if [ "$shuffle" = true ]; then
	echo "Shuffling '$playlist'..."
	mplayer -loop 0 -shuffle -playlist $playlistFile
else
	echo "Playing '$playlist' in order..."
	mplayer -loop 0 -playlist $playlistFile
fi
