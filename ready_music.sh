#!/bin/bash

youtube-dl --rm-cache-dir 

while :
do
  rm -f temp.txt
  
  # Use zenity to interact with user. A welcome page with all features. Store the feature user choose in variable ask 
  ask=`zenity --list --title="Welcome to Ready-Music!" --column="0" "Play One Song" "Play Playlist" "Add Song to Playlist" "Remove Song from Playlist" "Delete Song" "*Get Recommendations for Playlist*" --width=280 --height=230 --hide-header`
 
  # If usr choose cancel, exit with code 1 
  [[ "$?" != "0" ]] && exit 1

  # if user choose "play one song", then ask for keywords 
  if [ "$ask" == "Play One Song" ]; then
    query=`zenity --entry --title "Play One Song" --text "Enter song keywords:"`
    
    # if choose cancel, continue to go back to the welcome page 
    [[ "$?" != "0" ]] && continue

		# else, call play_one.sh in scripts folder 
    scripts/./play_one.sh $query
  fi
  
  # if user choose "play playlist"
  if [ "$ask" == "Play Playlist" ]; then

    # find all playlists
    allPlaylists=$(find ~/Desktop/songs/playlists -type f -name "*.m3u" -exec basename {} \;)
		allPlaylists=$(echo $allPlaylists | sed 's/\.m3u/ /g')

    # ask the usr to chose one playlist to play
    playlist=`zenity --entry --title "Play Playlist" --text "Playlists: $allPlaylists \n"`
    
    # if choose cancel, continue to go back to the welcome page 
    [[ "$?" != "0" ]] && continue
		
    # ask user if shuffle or not
    if zenity --question --width 100 --text "Shuffle?"; then
			
      # call play_playlist.sh -s if user choose to shuffle
      scripts/./play_playlist.sh -s $playlist

    else
      # call play_playlist.sh otherwise
      scripts/./play_playlist.sh $playlist
    fi
  fi

  # if user choose "add song to playlist" 
  if [ "$ask" == "Add Song to Playlist" ]; then
    
    # find all playlists
    allPlaylists=$(find ~/Desktop/songs/playlists -type f -name "*.m3u" -exec basename {} \;)
    allPlaylists=$(echo $allPlaylists | sed 's/\.m3u/ /g')

    # ask user to choose one playlist/ or create a new playlist to add song.
    # Note: the name of playlist should be s. Note: the name of playlist should be single word
    playlist=`zenity --entry --title "Which Playlist?" --text "Playlists: $allPlaylists \n (Or create a new playlist)"`
    
    # if choose cancel, continue to go back to the welcome page
    [[ "$?" != "0" ]] && continue
   
    # then ask user to enter keywords for the song
		query=`zenity --entry --title "What Song?" --text "Enter song keywords:"`
		
    # if choose cancel, continue to go back to the welcome page
    [[ "$?" != "0" ]] && continue

		# run add_to_playlist.sh otherwise
    scripts/./add_to_playlist.sh $playlist $query	
  fi

  # if user choose "Get Recommendations for Playlist*"
  if [ "$ask" == "*Get Recommendations for Playlist*" ]; then
    
    # find all playlists
    allPlaylists=$(find ~/Desktop/songs/playlists -type f -name "*.m3u" -exec basename {} \;)
    allPlaylists=$(echo $allPlaylists | sed 's/\.m3u/ /g')
    
    # ask user to choose one playlist/ or create a new playlist to add song.
    playlist=`zenity --entry --width=200 --title "Choose a Playlist" --text "Playlists: $allPlaylists \n"`
    
    # if choose cancel, continue to go back to the welcome page
    [[ "$?" != "0" ]] && continue

    # get the path to the playlist
    path=$(echo $HOME/Desktop/songs/playlists/$playlist.m3u) 

		# create a temp.txt to store the song list
    touch temp.txt
    scripts/./get_songs.py $path temp.txt

    # create pattern to match artists (usually before a dash)
    pattern="([a-zA-Z0-9[:space:]]+)\-"
    old=$IFS
    IFS=$'\n'
    artists=($(grep -E -o "$pattern" "temp.txt"))
		
    # if playlist has no songs with words before a dash, echo failure msg and continue to welcome page
    if [ ${#artists[@]} -eq 0 ]; then
      zenity --info --width=150 --height=120 --text "Unable to find recommendations for this playlist (no artists found)."
      continue
    fi
		
    # Echo process songs msg otherwise
    zenity --info --width=150 --height=120 --text "Hit OK to find songs similar to $playlist! This may take up to 5 minutes."
    
    # if choose cancel, continue to go back to the welcome page
    [[ "$?" != "0" ]] && continue
	
    # create array from artists
    eval artists=($(printf "%q\n" "${artists[@]}" | sort -u))
    echo "${artists[@]}"
    touch ~/Desktop/songs/recommendations.txt
    > ~/Desktop/songs/recommendations.txt
    IFS=$old
    count=0

    # iterate over artist in the array
    for artist in "${artists[@]}"; do
      echo "artist: $artist"
      
      # call recommend.sh to find recommended songs for each artist
      scripts/./recommend.sh $artist
      
      # count increment
      ((count++))
			
      # Only do most recent 7 artists
      if [ $count == 7 ]; then
        break
      fi
    done

		# store the songs in recommendation.txt file in variable recommended
    recommended=$(cat ~/Desktop/songs/recommendations.txt)

    # allow user to add songs that are recommended
    while :
    do
			
      # get the song to add from user
      toAdd=`eval zenity --list --title="Recommended-Songs" --column=$recommended --hide-header --width=460 --height=600`
      
      # if choose cancel, continue to go back to the welcome page
      [[ "$?" != "0" ]] && break
      
      # if toadd file is empty, then continue
      if [ -z "$toAdd" ]; then
        continue
      fi
			
      # echo msg to add song
      zenity --info --width=150 --height=120 --text "Add '$toAdd' to playlist '$playlist'?"
			
      # if choose cancel, continue to go back to the welcome page
      [[ "$?" != "0" ]] && continue

      # call add_to_playlist.sh 
      scripts/./add_to_playlist.sh $playlist $toAdd
		
    # finish the loop and rm the temp file   
    done
    rm temp.txt
  fi

  # if user choose "Remove Song from Playlist"
  if [ "$ask" == "Remove Song from Playlist" ]; then
    
    # find all playlists
    allPlaylists=$(find ~/Desktop/songs/playlists -type f -name "*m3u" -exec basename {} \;)
    allPlaylists=$(echo $allPlaylists | sed 's/\.m3u/ /g') 
    
    # ask user to choose one playlist
    playlist=`zenity --entry --title "Which Playlist?" --text "Playlists: $allPlaylists \n"`
   
    # if choose cancel, continue to go back to the welcome page
    [[ "$?" != "0" ]] && continue
   
    # get the path of the chosen playlist
    path=$(echo $HOME/Desktop/songs/playlists/$playlist.m3u) 
  
    # create a temp.txt to store the song list
    touch temp.txt

    # run script get_songs.py to get song list and store in variable temp, then
    scripts/./get_songs.py $path temp.txt
    temp=$(cat temp.txt)
    rm temp.txt
    
    # ask user to choose the song to remove
    to_remove=`eval zenity --list --title="Which-Song?" --column=$temp --hide-header --width=460 --height=600`
   
    # if choose cancer, continue to go back to the welcome page
    [[ "$?" != "0" ]] && continue

    # if to_remove is empty, continue to welcome page
    if [ -z "$to_remove" ]; then
        continue
    fi

    # run script get_line.py to find the line of song
    line=$(scripts/./get_line.py $path $to_remove)
    
    # delete the song from songlist and echo done
    sed "${line}d" $path > $HOME/Desktop/songs/playlists/temp.m3u
    rm $path
    mv $HOME/Desktop/songs/playlists/temp.m3u $path
    echo "Song '$to_remove' removed from playlist '$playlist'"
  fi

  # if user choose "Delete Song"
  if [ "$ask" == "Delete Song" ]; then
    
    # find all songs user have and store in variable temp 
    find ~/Desktop/songs -type f -name "*.mp3" -exec basename {} \; > temp1.txt
    cat temp1.txt | sed 's/\.mp3//g' > temp2.txt
    cat temp2.txt | sed 's/$/"/' > temp1.txt
    cat temp1.txt | sed 's/^/"/' > temp2.txt
    temp="\"0\" $(cat temp2.txt)"
    rm temp*
    
    # ask user which song to delete from all songs
    to_delete=`eval zenity --list --title="Which-Song?" --column=$temp --hide-header --width=460 --height=600` 
    
    # if choose cancer, continue to go back to the welcome page
    [[ "$?" != "0" ]] && continue

    # if to_delete empty, continue to welcome page
    if [ -z "$to_delete" ]; then
        continue
    fi

    # find the path to the song chosen and delete song from dataset
    path=$(echo $HOME/Desktop/songs/$to_delete.mp3)
    rm "$path"

    # echo success msg
    echo "Song '$to_delete' was deleted" 

    #find all playlists 
    allPlaylists=$(find ~/Desktop/songs/playlists -type f -name "*m3u" -exec basename {} \;)
    allPlaylists=$(echo $allPlaylists | sed 's/\.m3u/ /g')
    
    # iterate over all playlist 
    for playlist in $allPlaylists; do

      # use get_line.py to get line of song if included/ None if not included
      path_playlist=$(echo $HOME/Desktop/songs/playlists/$playlist.m3u)
      line=$(scripts/./get_line.py $path_playlist $to_delete)
      
      # if line is None echo not existed msg
      if [ $line == "None" ]; then
        echo "Song '$to_delete' not in playlist '$playlist'"
      
      # else remove the song from that list and echo success msg
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

