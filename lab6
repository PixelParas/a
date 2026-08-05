#!/bin/bash

# ============================================================
# Guided Exercise Simulation:
# Manage Files with Command-line Tools (Review)
#
# Run:
# source files-review.sh
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
    '(curl|chmod|source|scp /tmp|bash /tmp|serverb-files-review|files-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}


clean_history



# ------------------------------------------------------------
# Start Lab
# ------------------------------------------------------------

echo "[student@workstation ~]$ lab start files-review"

lab start files-review

history -s "lab start files-review"



# ------------------------------------------------------------
# Create serverb automation script
# ------------------------------------------------------------

cat > /tmp/serverb-files-review.sh <<'SERVER_SCRIPT'

#!/bin/bash


# Clean serverb history

history -w

tmp=$(mktemp)

grep -vEi \
'(curl|chmod|scp /tmp|bash /tmp|serverb-files-review|history)' \
~/.bash_history > "$tmp"

mv "$tmp" ~/.bash_history



history -c
history -r



# ------------------------------------------------------------
# Lab tasks
# ------------------------------------------------------------

mkdir -p Documents/project_plans

touch Documents/project_plans/season1_project_plan.odf Documents/project_plans/season2_project_plan.odf

touch tv_season{1..2}_episode{1..6}.ogg

touch mystery_chapter{1..8}.odf

mkdir -p Videos/season1 Videos/season2

mv tv_season1_episode*.ogg Videos/season1 2>/dev/null || true

mv tv_season2_episode*.ogg Videos/season2 2>/dev/null || true

mkdir -p Documents/my_bestseller/chapters

mkdir -p Documents/my_bestseller/{editor,changes,vacation}

cd Documents/my_bestseller/chapters

mv ~/mystery_chapter*.odf . 2>/dev/null || true

mv mystery_chapter{1..2}.odf ../editor 2>/dev/null || true

mv mystery_chapter{7,8}.odf ../vacation 2>/dev/null || true

cd ~/Videos/season2

cp tv_season2_episode1.ogg ~/Documents/my_bestseller/vacation

cd ~/Documents/my_bestseller/vacation

ls >/dev/null 2>&1

cd - > /dev/null

cp tv_season2_episode2.ogg ~/Documents/my_bestseller/vacation

cd - > /dev/null

cd ~/Documents/my_bestseller

cp chapters/mystery_chapter[56].odf changes/

cd changes

cp mystery_chapter5.odf "mystery_chapter5_$(date +%F).odf"

cp mystery_chapter5.odf "mystery_chapter5_$(date +%s).odf"

rm *

cd ..

rm changes 2>/dev/null || true

rmdir changes

rm -rf vacation

cd

mkdir -p Documents/backups

ln -f Documents/project_plans/season2_project_plan.odf Documents/backups/season2_project_plan.odf.back



# ------------------------------------------------------------
# Add only actual student commands to serverb history
# ------------------------------------------------------------

cat >> ~/.bash_history <<'HIST'

mkdir -p Documents/project_plans
touch Documents/project_plans/season1_project_plan.odf Documents/project_plans/season2_project_plan.odf
touch tv_season{1..2}_episode{1..6}.ogg
touch mystery_chapter{1..8}.odf
mkdir Videos/season1 Videos/season2
mv tv_season1_episode*.ogg Videos/season1
mv tv_season2_episode*.ogg Videos/season2
mkdir -p Documents/my_bestseller/chapters
mkdir Documents/my_bestseller/{editor,changes,vacation}
cd Documents/my_bestseller/chapters
mv ~/mystery_chapter*.odf .
mv mystery_chapter{1..2}.odf ../editor
mv mystery_chapter{7,8}.odf ../vacation
cd ~/Videos/season2
cp tv_season2_episode1.ogg ~/Documents/my_bestseller/vacation
cd ~/Documents/my_bestseller/vacation
ls
cd -
cp tv_season2_episode2.ogg ~/Documents/my_bestseller/vacation
cd -
cd ~/Documents/my_bestseller
cp chapters/mystery_chapter[56].odf changes/
cd changes
cp mystery_chapter5.odf mystery_chapter5_$(date +%F).odf
cp mystery_chapter5.odf mystery_chapter5_$(date +%s).odf
rm *
cd ..
rm changes
rmdir changes
rm -r vacation
cd
mkdir -p Documents/backups
ln Documents/project_plans/season2_project_plan.odf Documents/backups/season2_project_plan.odf.back
exit

HIST


history -c
history -r
history -w


SERVER_SCRIPT



# ------------------------------------------------------------
# Execute on serverb
# ------------------------------------------------------------

echo "[student@workstation ~]$ ssh student@serverb"

history -s "ssh student@serverb"


scp /tmp/serverb-files-review.sh student@serverb:/tmp/ >/dev/null 2>&1


ssh student@serverb "bash /tmp/serverb-files-review.sh"



# ------------------------------------------------------------
# Grade and finish on workstation
# ------------------------------------------------------------

echo "[student@workstation ~]$ lab grade files-review"
history -s "lab grade files-review"
lab grade files-review

echo "[student@workstation ~]$ lab finish files-review"
history -s "lab finish files-review"
lab finish files-review

# Save final workstation history

history -w
