#!/usr/bin/env bash

# This version uses curl and pipes the https url so mpg123 can read it.
# This is done because mpg123 doesn't handle https request yet.
# Also updated how the process is hungup so we don't killall processes that may or maynot be related to mpg123
# Added favorites option to save and play favorite URLS, and also a help menu.

# To Run Open Terminal to the location of the script and type `bash ./music_thingy.bash`


set -f

xcleanup_thingy(){ 
[[ -e /tmp/music_thingy.pid ]] && kill -1 $(</tmp/music_thingy.pid) && rm /tmp/music_thingy.pid
}

cleanup_thingy(){		
mapfile pids <<< $pids	
	if [[ ${#pids[*]} -gt 1 ]];then
		pid0="${pids[0]}"
		pid0=(${pid0})
		kill -1 "${pid0[1]}"		
		pid1="${pids[1]}"
		pid1=(${pid1})
		kill -1 "${pid1[1]}" 		
        fi
}
vol() {
for l in "$(amixer get Master)"
	do
		 l=${l// /_}  
 	         l=${l/_[/ }
 		 l=${l/]_/ }
  		 l=($l)
  		 s="${l[5]}"
  
  		 #Fix for raspberry pi *** maybe outdated 
 		 [[ ${#s} -gt 3 ]] && s="${l[6]}"  

  		  soundlevel=${s//%/}
  		  inc_sound=$(($soundlevel + 5))
  		  dec_sound=$(($soundlevel - 5))

  		  [[ $REPLY == + ]] && amixer -q set Master $(($soundlevel + 5))% && s=$(($soundlevel + 5))%
  		  [[ $REPLY == - ]] && amixer -q set Master $(($soundlevel - 5))% && s=$(($soundlevel - 5))%  
  		  [[ $REPLY == m ]] && amixer -q set Master mute && s=Muted
  		  [[ $REPLY == u ]] && amixer -q set Master unmute 
  		  echo "${s}"  			
	done
							
} 

	playlist="https://ice1.somafm.com/7soul-128-mp3#Seven Inch Soul - Vintage soul tracks from the original 45 RPM vinyl.
	https://ice4.somafm.com/beatblender-128-mp3#Beat Blender - A late night blend of deep-house and downtempo chill.
	https://ice4.somafm.com/bootliquor-128-mp3#Boot Liquor - Americana Roots music for Cowhands, Cowpokes and Cowtippers
	https://ice6.somafm.com/brfm-128-mp3#Black Rock FM - From the Playa to the world, for the annual Burning Man festival.
	https://ice6.somafm.com/cliqhop-128-mp3#cliqhop idm - Blips'n'beeps backed mostly w/beats. Intelligent Dance Music.
	https://ice4.somafm.com/covers-128-mp3#Covers - Just covers. Songs you know by artists you don't. We've got you covered.
	https://ice4.somafm.com/deepspaceone-128-mp3#Deep Space One - Deep ambient electronic, experimental and space music. For inner and outer space exploration.
	https://ice2.somafm.com/defcon-128-mp3#DEF CON Radio - Music for Hacking. The DEF CON Year-Round Channel.
	https://ice2.somafm.com/digitalis-128-mp3#Digitalis - Digitally affected analog rock to calm the agitated heart.
	https://ice2.somafm.com/dubstep-128-mp3#Dub Step Beyond - Dubstep, Dub and Deep Bass. May damage speakers at high volume.
	https://ice4.somafm.com/dronezone-128-mp3#Drone Zone - Served best chilled, safe with most medications. Atmospheric textures with minimal beats.
	https://ice6.somafm.com/fluid-128-mp3#Fluid - Drown in the electronic sound of instrumental hiphop, future soul and liquid trap.
	https://ice6.somafm.com/folkfwd-128-mp3#Folk Forward - Indie Folk, Alt-folk and the occasional folk classics.
	https://ice4.somafm.com/groovesalad-128-mp3#Groove Salad - A nicely chilled plate of ambient/downtempo beats and grooves.
	https://ice1.somafm.com/gsclassic-128-mp3#Groove Salad Classic - The classic (early 2000s) version of a nicely chilled plate of ambient/downtempo beats and grooves.
	https://ice2.somafm.com/illstreet-128-mp3#Illinois Street Lounge - Classic bachelor pad, playful exotica and vintage music of tomorrow.
	https://ice6.somafm.com/indiepop-128-mp3#Indie Pop Rocks! - New and classic favorite indie pop tracks.
	https://ice6.somafm.com/live-128-mp3#SomaFM Live - Special Live Events and rebroadcasts of past live events.
	https://ice6.somafm.com/lush-128-mp3#Lush - Sensuous and mellow female vocals, many with an electronic influence.
	https://ice1.somafm.com/metal-128-mp3#Metal Detector - From black to doom, prog to sludge, thrash to post, stoner to crossover, punk to industrial.
	https://ice4.somafm.com/missioncontrol-128-mp3#Mission Control - Celebrating NASA and Space Explorers everywhere.
	https://ice1.somafm.com/n5md-128-mp3#n5MD Radio Emotional Experiments in Music: Ambient, modern composition, post-rock, & experimental electronic music.
	https://ice6.somafm.com/poptron-128-mp3#PopTron - Electropop and indie dance rock with sparkle and pop.
	https://ice6.somafm.com/u80s-128-mp3#Underground 80s - Early 80s UK Synthpop and a bit of New Wave.
	https://ice4.somafm.com/reggae-128-mp3#Heavyweight Reggae - Reggae, Ska, Rocksteady classic and deep tracks.
	https://ice6.somafm.com/scanner-128-mp3#SF Police Scanner - San Francisco Public Safety Scanner Feed.
	https://ice2.somafm.com/secretagent-128-mp3#Secret Agent - The soundtrack for your stylish, mysterious, dangerous life. For Spies and PIs too!
	https://ice6.somafm.com/seventies-128-mp3#Left Coast 70s - Mellow album rock from the Seventies. Yacht not required.
	https://ice4.somafm.com/sf1033-128-mp3#SF 10-33 - Ambient music mixed with the sounds of San Francisco public safety radio traffic.
	https://ice6.somafm.com/sonicuniverse-128-mp3#Sonic Universe - Transcending the world of jazz with eclectic, avant-garde takes on tradition.
	https://ice1.somafm.com/spacestation-128-mp3#Space Station - Soma Tune in, turn on, space out. Spaced-out ambient and mid-tempo electronica.
	https://ice2.somafm.com/specials-128-mp3#Department Store Christmas Holiday Elevator Music from a more innocent time. (Specials).
	https://ice4.somafm.com/suburbsofgoa-128-mp3#SSuburbs of Goa - Desi-influenced Asian world beats and beyond.
	https://ice1.somafm.com/synphaera-128-mp3#Synphaera Radio - Featuring the music from an independent record label focused on modern electronic ambient and space music.
	https://ice4.somafm.com/reggae-128-mp3#The Trip - Progressive house / trance. Tip top tunes.
	https://ice6.somafm.com/thistle-128-mp3#ThistleRadio - Exploring music from Celtic roots and branches
	https://ice1.somafm.com/vaporwaves-128-mp3#Vaporwaves - All Vaporwave. All the time."
	mapfile playlist <<< $playlist

# Add option to play argument given to command line. 
if [[ $1 ]];then
	playlist="$1"
	mapfile playlist <<< $playlist
	unset $1
fi
	
startplaying(){
header(){
	echo -e " * $(</tmp/music_thingy.info) \n   * Total Playlists ${#playlist[*]}\\n   * Vol $(vol)\\n"
}
xfooter(){
	[[ $REPLY == f && ${#playlist[*]} != 0 ]] && echo "${RED}Shuffling Favorites${BLUE} (-:"
	[[ $REPLY == f && ${#playlist[*]} == 0 ]] && echo "${RED}Favorites is empty. Press \"s\" then \"a\" to add to favorites.${BLUE} (-:"
	[[ $REPLY == s ]] && echo "${RED}Shuffling All${BLUE} (-:"
	[[ $REPLY == a ]] && echo "${RED}Added to favorites${BLUE} (-:"	
	[[ $REPLY == d ]] && echo "${RED}Deleted from favorites${BLUE} (-:"

}
footer(){
	echo -e "\\n\\n\\n\\n\\n${RED}${USER}${BLUE}@${ORANGE}Interactive Music Thingy${BLUE}~ $:-) $(xfooter) "
}
if [[ $REPLY == a ]];then
	mapfile playlist < $favs
	nu="0-$((${#playlist[*]}-1))"
	shuffle="$(shuf -i $nu -n 1)"
	pl="${playlist[$shuffle]}"
	tr=(${pl//\\n/\/ })
	tr=${tr[0]}
	tmp=$(</tmp/music_thingy.info) ### Repeat the delete cmds so no duplicate entries 
	foo=$(<$favs)
	echo "${foo//"$tmp"}" | sed '/^$/d' > $favs				
	fav=$(</tmp/music_thingy.info)
	echo $fav >> $favs			
fi
if [[ $REPLY == l ]];then
	echo -e "${BLUE}  ${RED}<Favorites>\\n${BLUE}\\n$(<$favs)"
	echo -e "\\n${BLUE}  ${RED}</Favorites>\\n${BLUE}"
	footer
	return
fi
if [[ $REPLY == d ]];then
	mapfile playlist < $favs
	nu="0-$((${#playlist[*]}-1))"
	shuffle="$(shuf -i $nu -n 1)"
	pl="${playlist[$shuffle]}"
	tr=(${pl//\\n/\/ })
	tr=${tr[0]}
	tmp=$(</tmp/music_thingy.info)
	foo=$(<$favs)
	echo "${foo//"$tmp"}" | sed '/^$/d' > $favs				
fi
if [[ ${REPLY} == h ]];then
	echo -e "${BLUE}  ${RED}<Help>\\n"				
	echo -e "${BLUE} * ${RED} [a]  Add to favorites"
	echo -e "${BLUE} * ${RED} [d]  Delete from favorites"	
	echo -e "${BLUE} * ${RED} [f]  Shuffle favorites"
	echo -e "${BLUE} * ${RED} [l]  List favorites"
	echo -e "${BLUE} * ${RED} [s]  Shuffle all"
	echo -e "${BLUE} * ${RED} [q]  Quit"
	echo -e "${BLUE} * ${RED} [m]  Mute"
	echo -e "${BLUE} * ${RED} [u]  Unmute"
	echo -e "${BLUE} * ${RED} [+]  Vol up"
	echo -e "${BLUE} * ${RED} [-]  Vol down"
	echo -e "${BLUE} * ${RED} [h]  Help menu"
	echo -e "${BLUE}  ${RED}\\n  </Help>\\n${BLUE}"
	footer
 return					
fi

if [[ $REPLY == f ]];then	
	mapfile playlist < $favs
	nu="0-$((${#playlist[*]}-1))"
	shuffle="$(shuf -i $nu -n 1)"
	pl="${playlist[$shuffle]}"
	tr=(${pl//\\n/\/ })
	tr=${tr[0]}
	cleanup_thingy
        (echo $BASHPID > /tmp/music_thingy.pid; exec -a MuSiC-ThInGy- curl -L  ${tr} -o /tmp/music_thingy.pipe & exec -a MuSiC-ThInGy- $player /tmp/music_thingy.pipe)&> /tmp/null &
        #echo
        url="${pl//,/\\n *}"
	url="${url//\ -\ /\\n * }"
	url="${url//.\ /\\n * }"
	url=(${url//#/\\n * })
	echo ${url[*]} > /tmp/music_thingy.info	
fi

if [[ $REPLY == s || ! $REPLY ]];then
        nu="0-$((${#playlist[*]}-1))"
	shuffle="$(shuf -i $nu -n 1)"
	pl="${playlist[$shuffle]}"
	tr=(${pl//#/\/ })
	tr=${tr[0]}
        cleanup_thingy
        (echo $BASHPID > /tmp/music_thingy.pid; exec -a MuSiC-ThInGy- curl -L  ${tr} -o /tmp/music_thingy.pipe & exec -a MuSiC-ThInGy- $player /tmp/music_thingy.pipe)&> /dev/null &        
        url="${pl//,/\\n *}"
	url="${url//\ -\ /\\n * }"
	url="${url//.\ /\\n * }"
	url=(${url//#/\\n * })
	echo ${url[*]} > /tmp/music_thingy.info	
fi

header
footer
}

header() {
tput -S <<!
clear
cup 10 
smso
bold
!
echo -e "${BLUE}                   Interactive Music Thingy               \n             https://github.com/ablyss74/                 \n   \
        [S]huffle/[Q]uit   Vol +/-   [H]elp Menu       \n       \n     \n   \n \n"
        
tput rmso

[[ ! -p /tmp/music_thingy.pipe ]] && mkfifo /tmp/music_thingy.pipe

startplaying	

}

while true
	do
		 player="mpg123"		 
		 BLUE="$(tput setaf 12)"    
		 RED="$(tput setaf 9)"
		 GREEN="$(tput setaf 46)"
		 NORM="$(tput setaf 15)"
		 ORANGE="$(tput setaf 9)" 
		 BLACK="$(tput setaf 234)" 
		 REPLY=${REPLY,,}		 
		 favs="${HOME}/.music_thingy_favorites.txt"
		 pids="$(ps -u | grep MuSiC-ThInGy-)"	 
		 x=($(${player%} --version))
		#[ -z ${x[0]} ]] && echo -e "\\n${ORANGE}${player}${RED} not installed. ${BLUE}Please install it to play music :-)\\n" && break
		 [[ -z ${x[0]} ]] && echo -e "\\n${ORANGE}${player}${RED} not installed. ${BLUE}Installing...:-)\\n" && swupd bundle-add mpg123
	
		 if [[ ${REPLY} == q ]];then
			 echo -e "\\n\\n${BLUE}bye!\\n\\n"
		 	 cleanup_thingy
		      break		 
		  else
		  	read -s -r -p "$(header)" -n 1	
		 fi	 
	done

