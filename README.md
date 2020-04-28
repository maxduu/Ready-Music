# CIS191FinalProject

# 1. Introduction to Ready-Music
Ready music is a command line program to help our users easily play the songs available in youtube, manage song library and personal playlists, and get song recommendations.
Just run ./ready_music.sh to start the program!
We use zenity so that it’s easy to use. There are six features on the welcome page: 
A. Play One Song: play one song based on users’ input query
B. Play Playlist: play the existed playlist, can choose to shuffle the playlist
C. Add Song to Playlist: add song to playlist already existed or newly created. 
D. Remove Song from Playlist: remove the song from playlist 
E. Delete Song: delete the song from song library and remove that song in any playlist if existed
F. *Get Recommendations for Playlist*: recommend songs based on one playlist, basically will recommend songs of the same singer as the currently added songs in the playlist. 

# 2. Set-up (packages to install before running the code)
Zenity - allows for dialog boxes in command line and bash script
Youtube-dl to download mp3 from youtube
Mplayer: the media player used to play the mp3 

TO DOWNLOAD Youtube-dl:
# sudo apt install curl
# sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
# sudo chmod a+rx /usr/local/bin/youtube-dl
# may have to do: sudo ln -s /usr/bin/python3 /usr/bin/python
