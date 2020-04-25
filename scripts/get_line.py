#!/usr/bin/python
#get_line.py playlist to_remove

import sys
import argparse

def parse_args():
    parser = argparse.ArgumentParser()

    #positional arguments
    parser.add_argument("playlist", help="path to playlist to get song line")
    parser.add_argument("songname",nargs="+", help="the song name to get line number")
    
    return parser.parse_args()

def list_to_string(songname):
    return ' '.join(str(word) for word in songname)


def read(playlist):
    songs = [line.rstrip('.mp3\n').lstrip('../') for line in open(playlist)]
    return songs

def get_song_dict(songs):
    song_dict = dict()
    for i in range(len(songs)):
        song = songs[i]
        song_dict[song] = i+1
    return song_dict

def get_line(song_dict, to_remove):
    if to_remove in song_dict:
        return song_dict[to_remove]
    else:
        return None

def main():
    #playlist = sys.argv[1]
    #to_remove = sys.argv[2]
    args = parse_args()
    playlist = args.playlist
    songname = args.songname
    
    to_remove=list_to_string(songname)
    songs = read(playlist)
    song_dict = get_song_dict(songs)
    line = get_line(song_dict, to_remove)
    print(line)

if __name__== '__main__':
    main()
    sys.exit(0)


