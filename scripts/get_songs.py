#!/usr/bin/python
#remove_song_from_playlist.py playlist output.txt

import sys

def read(playlist):
    
    # get song name in the playlist by removing prefix path and suffix extention
    songs = [line.rstrip('.mp3\n').lstrip('../') for line in open(playlist)] 
    return songs

def zenity(songs):

    # make the song lists works for zenity command by adding "0" before and save all songs within the quotes
    request = "\"0\""
    for song in songs:
        request += " \""+song+"\""
    return request

def main ():
    
    # get the input arguments and run functions to write all songs in the playlist in the output.txt
    playlist = sys.argv[1]
    songs = read(playlist)
    request = zenity(songs)

    with open(sys.argv[2], "w") as file:
        file.write(request)

if __name__== '__main__':
    main()
    sys.exit(0)

            
