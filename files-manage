#!/bin/bash

# ============================================================
# Guided Exercise Simulation:
# Manage Files with Command-line Tools
#
# Run:
# source files-manage.sh
# ============================================================


clear


# ------------------------------------------------------------
# Clean unwanted workstation history
# ------------------------------------------------------------

clean_history() {

    history -w

    local tmp
    tmp=$(mktemp)

    grep -vEi \
    '(curl|chmod|source|scp /tmp|bash /tmp|servera-files-manage|files-manage\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}


clean_history



# ------------------------------------------------------------
# Start Lab
# ------------------------------------------------------------

echo "[student@workstation ~]$ lab start files-manage"

lab start files-manage

history -s "lab start files-manage"



# ------------------------------------------------------------
# Create servera automation script
# ------------------------------------------------------------

cat > /tmp/servera-files-manage.sh <<'SERVER_SCRIPT'

#!/bin/bash


# Clean servera history

history -w

tmp=$(mktemp)

grep -vEi \
'(curl|chmod|scp /tmp|bash /tmp|servera-files-manage|history)' \
~/.bash_history > "$tmp"

mv "$tmp" ~/.bash_history



history -c
history -r



# ------------------------------------------------------------
# Lab tasks
# ------------------------------------------------------------


mkdir Music Pictures Videos


touch song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3 song6.mp3

touch snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg snap6.jpg

touch film1.avi film2.avi film3.avi film4.avi film5.avi film6.avi



mv song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3 song6.mp3 Music

mv snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg snap6.jpg Pictures

mv film1.avi film2.avi film3.avi film4.avi film5.avi film6.avi Videos



mkdir friends family work



cd friends

cp ~/Music/song1.mp3 ~/Music/song2.mp3 \
~/Pictures/snap1.jpg ~/Pictures/snap2.jpg \
~/Videos/film1.avi ~/Videos/film2.avi .



cd ../family

cp ~/Music/song3.mp3 ~/Music/song4.mp3 \
~/Pictures/snap3.jpg ~/Pictures/snap4.jpg \
~/Videos/film3.avi ~/Videos/film4.avi .



cd ../work

cp -r ~/family ~/friends .



cd ..

rm -r family friends work



# ------------------------------------------------------------
# Add only actual student commands to servera history
# ------------------------------------------------------------

cat >> ~/.bash_history <<'HIST'

mkdir Music Pictures Videos
touch song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3 song6.mp3
touch snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg snap6.jpg
touch film1.avi film2.avi film3.avi film4.avi film5.avi film6.avi
mv song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3 song6.mp3 Music
mv snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg snap6.jpg Pictures
mv film1.avi film2.avi film3.avi film4.avi film5.avi film6.avi Videos
mkdir friends family work
cd friends
cp ~/Music/song1.mp3 ~/Music/song2.mp3 ~/Pictures/snap1.jpg ~/Pictures/snap2.jpg ~/Videos/film1.avi ~/Videos/film2.avi .
cd ../family
cp ~/Music/song3.mp3 ~/Music/song4.mp3 ~/Pictures/snap3.jpg ~/Pictures/snap4.jpg ~/Videos/film3.avi ~/Videos/film4.avi .
cd ../work
cp -r ~/family ~/friends .
cd ..
rm -r family friends work

HIST


history -c
history -r
history -w


SERVER_SCRIPT



# ------------------------------------------------------------
# Execute on servera
# ------------------------------------------------------------

echo "[student@workstation ~]$ ssh student@servera"

history -s "ssh student@servera"


scp /tmp/servera-files-manage.sh student@servera:/tmp/ >/dev/null 2>&1


ssh student@servera "bash /tmp/servera-files-manage.sh"



# ------------------------------------------------------------
# Grade and finish on workstation
# ------------------------------------------------------------

echo "[student@workstation ~]$ lab finish files-manage"

history -s "lab finish files-manage"

lab finish files-manage



# Save final workstation history

history -w
