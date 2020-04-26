#!/bin/bash

# if downloading broken, type youtube-dl --rm-cache-dir
while :
do
	ask=`zenity --list --title="Welcome to Ready-Music!" --column="0" "Play One Song" "Play Playlist" "Add Song to Playlist" "Remove Song from Playlist" "Delete Song" --width=100 --height=300 --hide-header`
	[[ "$?" != "0" ]] && exit 1

	if [ "$ask" == "Play One Song" ]; then
		query=`zenity --entry --title "Play One Song" --text "Enter song keywords:"`
		[[ "$?" != "0" ]] && continue

		# CALL SCRIPT
		scripts/./play_one.sh $query
	fi

	if [ "$ask" == "Play Playlist" ]; then
		allPlaylists=$(find ~/Desktop/songs/playlists -type f -name "*.m3u" -exec basename {} \;)
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
		allPlaylists=$(find ~/Desktop/songs/playlists -type f -name "*.m3u" -exec basename {} \;)
		allPlaylists=$(echo $allPlaylists | sed 's/\.m3u/ /g')
		playlist=`zenity --entry --title "Which Playlist?" --text "Playlists: $allPlaylists \n (Or create a new playlist)"`
		[[ "$?" != "0" ]] && continue
		query=`zenity --entry --title "What Song?" --text "Enter song keywords:"`
		[[ "$?" != "0" ]] && continue

		# CALL SCRIPT
		scripts/./add_to_playlist.sh $playlist $query	
	fi

	if [ "$ask" == "Remove Song from Playlist" ]; then
		allPlaylists=$(find ~/Desktop/songs/playlists -type f -name "*m3u" -exec basename {} \;)
    allPlaylists=$(echo $allPlaylists | sed 's/\.m3u/ /g') 
    playlist=`zenity --entry --title "Which Playlist?" --text "Playlists: $allPlaylists \n"`
    [[ "$?" != "0" ]] && continue
    path=$(echo $HOME/Desktop/songs/playlists/$playlist.m3u) 
  
    #query=`zenity --entry --title "What Song?" --text "Enter song keywords:"`
    #[[ "$?" != "0" ]] && continue

    #create a temp.txt to store the song list
    touch temp.txt
    scripts/./get_songs.py $path temp.txt
    temp=$(cat temp.txt)
    rm temp.txt
    
    to_remove=`eval zenity --list --title="Which-Song?" --column=$temp --hide-header --width=400 --height=600`
    [[ "$?" != "0" ]] && continue
    if [ -z "$to_remove" ]; then
        continue
    fi
    # delete the song from songlist and echo done
    line=$(scripts/./get_line.py $path $to_remove)
    sed "${line}d" $path > $HOME/Desktop/songs/playlists/temp.m3u
    rm $path
    mv $HOME/Desktop/songs/playlists/temp.m3u $path
    echo "Song '$to_remove' removed from playlist '$playlist'"
  fi

  if [ "$ask" == "Delete Song" ]; then
    find ~/Desktop/songs -type f -name "*.mp3" -exec basename {} \; > temp1.txt
    cat temp1.txt | sed 's/\.mp3//g' > temp2.txt
    cat temp2.txt | sed 's/$/"/' > temp1.txt
    cat temp1.txt | sed 's/^/"/' > temp2.txt
    temp="\"0\" $(cat temp2.txt)"
    rm temp*

    to_delete=`eval zenity --list --title="Which-Song?" --column=$temp --hide-header --width=400 --height=600` 
    [[ "$?" != "0" ]] && continue
    #delete song from dataset
    if [ -z "$to_delete" ]; then
        continue
    fi
    path=$(echo $HOME/Desktop/songs/$to_delete.mp3)
    rm "$path"
    echo "Song '$to_delete' was deleted" 

    #CALL SCRIPT
    allPlaylists=$(find ~/Desktop/songs/playlists -type f -name "*m3u" -exec basename {} \;)
    allPlaylists=$(echo $allPlaylists | sed 's/\.m3u/ /g')
    for playlist in $allPlaylists; do
      path_playlist=$(echo $HOME/Desktop/songs/playlists/$playlist.m3u)
      line=$(scripts/./get_line.py $path_playlist $to_delete)
      
      #If line is None
      if [ $line == "None" ]; then
        echo "Song '$to_delete' not in playlist '$playlist'"
      else
        sed "${line}d" $path_playlist > $HOME/Desktop/songs/playlists/temp.m3u
        rm $path_playlist
        mv $HOME/Desktop/songs/playlists/temp.m3u $path_playlist
        echo "Song '$to_delete' in playlist '$playlist', and it has been removed"
      fi
    done
  fi
sleep 1
done







