# CIS191FinalProject

# 1. Introduction to Ready-Music
Ready music is a command line program to help our users easily play the songs available in youtube, manage song library and personal playlists, and get song recommendations. <br>
Just run ./ready_music.sh to start the program! <br>
We use zenity so that it’s easy to use. There are six features on the welcome page: <br>
A. Play One Song: play one song based on users’ input query <br>
B. Play Playlist: play the existed playlist, can choose to shuffle the playlist <br>
C. Add Song to Playlist: add song to playlist already existed or newly created. <br>
D. Remove Song from Playlist: remove the song from playlist <br>
E. Delete Song: delete the song from song library and remove that song in any playlist if existed <br>
F. *Get Recommendations for Playlist*: recommend songs based on one playlist, basically will recommend songs of the same singer as the currently added songs in the playlist. <br>

# 2. Set-up (packages to install before running the code)
Zenity - allows for dialog boxes in command line and bash script <br>
Youtube-dl to download mp3 from youtube <br>
Mplayer: the media player used to play the mp3 <br>

TO DOWNLOAD Youtube-dl:
 sudo apt install curl <br>
 sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl <br>
 sudo chmod a+rx /usr/local/bin/youtube-dl <br>
 may have to do: sudo ln -s /usr/bin/python3 /usr/bin/python <br>
