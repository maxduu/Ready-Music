#!/bin/bash

while :
do
	ask=`zenity --list --title="Welcome to Ready-Music!" --column="0" "Play One Song" "Play Playlist" "Add Song to Playlist" "Remove Song from Playlist" --width=100 --height=200 --hide-header`
	[[ "$?" != "0" ]] && exit 1

	if [ "$ask" == "Play One Song" ]; then
		query=`zenity --entry --title "Play One Song" --text "Enter song keywords:"`
		[[ "$?" != "0" ]] && continue

		# CALL SCRIPT
		scripts/./play_one.sh $query
	fi

	if [ "$ask" == "Play Playlist" ]; then
		allPlaylists=$(find ~/Desktop/songs/playlists -type f -name "*.m3u" -printf "%f\n")
		allPlaylists=$(echo $allPlaylists | sed 's/\.m3u/ /g')

		playlist=`zenity --entry --title "Play Playlist" --text "Playlists: $allPlaylists"`
		[[ "$?" != "0" ]] && continue
		if zenity --question --width 100 --text "Shuffle?"; then
			# CALL SCRIPT
			scripts/./play_playlist.sh -s $playlist
		else
			# CALL SCRIPT
			scripts/./play_playlist.sh $playlist
		fi
	fi

	if [ "$ask" == "Add Song to Playlist" ]; then
		allPlaylists=$(find ~/Desktop/songs/playlists -type f -name "*.m3u" -printf "%f\n")
		allPlaylists=$(echo $allPlaylists | sed 's/\.m3u/ /g')
		playlist=`zenity --entry --title "Which Playlist?" --text "Playlists: $allPlaylists \n (Or create a new playlist)"`
		[[ "$?" != "0" ]] && continue
		query=`zenity --entry --title "What Song?" --text "Enter song keywords:"`
		[[ "$?" != "0" ]] && continue

		# CALL SCRIPT
		scripts/./add_to_playlist.sh $playlist $query	
	fi

	if [ "$ask" == "Remove Song From Playlist" ]; then
		# Not done
		echo "View Playlist"
	fi
sleep 1
done







