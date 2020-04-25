#!/usr/bin/python
#remove_song_from_playlist.py playlist txt #query

import sys

def read(playlist):
    #get a list of string
    #path = "~/Desktop/songs/playlists/" + playlist + ".m3u"
    songs = [line.rstrip('.mp3\n').lstrip('../') for line in open(playlist)] 
    return songs
'''
def find(lines, query):
    songs = []
    for line in lines:
        if query.lower() in line.lower()
        songs.add(line)
    return songs
'''
def zenity(songs):
    request = "\"0\""
    for song in songs:
        request += " \""+song+"\""
    return request

def main ():
    
    playlist = sys.argv[1]
    #query = sys.argv[2]

    #
    songs = read(playlist)
    #songs = find(lines, query)
    request = zenity(songs)

    with open(sys.argv[2], "w") as file:
        file.write(request)

if __name__== '__main__':
    main()
    sys.exit(0)

            
