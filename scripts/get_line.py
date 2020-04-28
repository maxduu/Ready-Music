#!/usr/bin/python
# usage: get_line.py playlist to_remove
# get the number of line of song in the playlist if existed, none if not existed

import argparse

def parse_args():
    parser = argparse.ArgumentParser()

    #positional arguments
    parser.add_argument("playlist", help="path to playlist to get song line")
    parser.add_argument("songname",nargs="+", help="the song name to get line number")
    
    return parser.parse_args()

def list_to_string(songname):
    
    # songname is a list of words
    return ' '.join(str(word) for word in songname)

def read(playlist):

    #remove the prefix path and suffix extension 
    songs = [line.rstrip('.mp3\n').lstrip('../') for line in open(playlist)]
    return songs

def get_song_dict(songs):

    # get a dictionary of songs with key = songname and value = line number
    song_dict = dict()
    for i in range(len(songs)):
        song = songs[i]
        song_dict[song] = i+1
    return song_dict

def get_line(song_dict, to_remove):

    # get the line number of to_remove song if existed in the playlist
    if to_remove in song_dict:
        return song_dict[to_remove]

    # return None if doesn't exist
    else:
        return None

def main():
    
    # get the input arguments 
    args = parse_args()
    playlist = args.playlist
    songname = args.songname
    
    # use functions define to get the line of to_remove song in playlist
    to_remove=list_to_string(songname)
    songs = read(playlist)
    song_dict = get_song_dict(songs)
    line = get_line(song_dict, to_remove)
    print(line)

if __name__== '__main__':
    main()
    sys.exit(0)


