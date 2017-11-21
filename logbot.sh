#!/bin/bash
# Find Logbot installation directory & set logs directory
LOGBOT_DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
LOGBOT_LOGS_DIR=$LOGBOT_DIR"/logs"

# Load user's custom config
source config/logbot.conf

# Detect OS type
OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'
    rand='shuf'
    ;;
  'Darwin')
    OS='Mac'
    rand='gshuf'
    ;;
  *) ;;
esac

# Get starting date
DATE=`date +%d-%m-%Y_%H:%M:%S`

# Randomize values used later in the program
RAND_MIN=`$rand -i $RAND_MIN_SCOPE -n 1`
RAND_MAX=`$rand -i $RAND_MAX_SCOPE -n 1`
RAND_SCOPE="$RAND_MIN-$RAND_MAX"
RAND=`$rand -i $RAND_SCOPE -n 1`

# Get SVN Projets number and randomly pick one of them
SVN_PROJECTS_NUMBER=${#SVN_PROJECTS[@]}
SVN_PROJECTS_CONTENT=${SVN_PROJECTS[@]}
RAND_PROJECT_NUMBER=`$rand -i 1-$SVN_PROJECTS_NUMBER -n 1`

# Colors Definitions
Black='\033[0;30m'
DarkGray='\033[1;30m'
Red='\033[0;31m'
LightRed='\033[1;31m'
Green='\033[0;32m'
LightGreen='\033[1;32m'
Yellow='\033[0;33m'
YellowBold='\033[1;33m'
Blue='\033[0;34m'
BlueBold='\033[1;34m'
Purple='\033[0;35m'
PurpleBold='\033[1;35m'
Cyan='\033[0;36m'
CyanBold='\033[1;36m'
LightGray='\033[0;37m'
White='\033[1;37m'
NC='\033[0m'		# No Color

# Console outputs starts here
echo -e "${Red}"
echo " _                  ______             ";
echo "( )                (  __  \        _   ";
echo "| |      ___   ____| |__)  ) ___ _| |_ ";
echo "| |     / _ \ / _  |  __  ( / _ (_   _)";
echo "| |____| |_| ( (_| | |__)  ) |_| || |_ ";
echo "|_______)___/ \___ |______/ \___/  \__)";
echo "             (_____|                   ";
echo -e "         Running on ${Yellow}$OS    ";
echo -e "${NC}"

if [ "$TESTING" = true ] ; then
    echo -e "${Green}LogBot is running in ${Yellow}testing mode${Green}. Future actions ${Yellow}will not${Green} be really done.${NC}"
fi

echo -e "${Green}LogBot started at${Yellow}" $DATE "${NC}"

echo -e "\n${Green}STEP 0 : LogBot checks your system and custom configuration (from ${Yellow}${LOGBOT_DIR}/config/logbot.conf${Green}) ${NC}"

# Check system requirements
if [[ $OS == "Mac" ]]
then
command -v gshuf >/dev/null 2>&1 || { echo >&2 -e "${Red}LogBot requires 'gshuf' but it's not installed. You can get it via '${LightRed}sudo brew install coreutils${Red}'.${NC}"; exit 1; }
fi

# Check custom user's config
ERRORS=0
for (( i = 0; i < $SVN_PROJECTS_NUMBER; i++ ))
do
        if [[ -d "${SVN_PROJECTS[$i]}" ]]
        then
                if  [[ -d "${SVN_PROJECTS[$i]}/.svn" ]]
                then
                        continue
                else
                        echo -e "${Red}Your custom${LightRed} ${SVN_PROJECTS[$i]}${Red} is not an initialized SVN directory. Please initialize it first (svn clone ...).${NC}"
			(( ERRORS++ ))
                fi
        else
                echo -e "${Red}Your custom${LightRed} ${SVN_PROJECTS[$i]} ${Red}directory does not exist. Check it's path and file permissions.${NC}"
		(( ERRORS++ ))
        fi
done

if [[ $ERRORS -ne 0 ]]
then
	echo -e "\n${Red}Oops ! LogBot was not able to load your custom config. Please fix these errors before going further.${NC}"
	exit 1
else
	echo -e "${Green}Perfect ! LogBot successfully loaded your custom config file.${NC}"
fi

echo -e "\n${Green}STEP 1 : LogBot waits${Yellow}" $RAND "${Green}seconds before starting.${NC}"
echo -e "${Cyan}$rand -i $RAND_SCOPE -n 1 = $RAND ${NC}"
echo -e "${Cyan}sleep $RAND ${NC}"

if [ "$TESTING" = false ] ; then
    sleep $RAND
fi

echo -e "\n${Green}STEP 2 : LogBot has to select a random SVN project, from a total list of :${Yellow}" $SVN_PROJECTS_NUMBER "${Green}project(s).${NC}"
echo -e "${Green}Logbot chose this time the SVN Project number${Yellow}" $RAND_PROJECT_NUMBER "${NC}"
for (( i = 0; i < $SVN_PROJECTS_NUMBER; i++ ))
do
	if [[ "$(( i + 1 ))" -eq "$RAND_PROJECT_NUMBER" ]]
	then
		echo -e "${LightGreen}" $(( i + 1 ))"/"$SVN_PROJECTS_NUMBER" : "${SVN_PROJECTS[$i]} "   <--- This one${NC}"
	else
		echo -e "${Yellow}" $(( i + 1 ))"/"$SVN_PROJECTS_NUMBER" : "${SVN_PROJECTS[$i]} "${NC}"
	fi
done

echo -e "\n${Green}STEP 3 : LogBot goes into this project folder.${NC}"
echo -e "${Cyan}cd ${Yellow}${SVN_PROJECTS[$RAND_PROJECT_NUMBER-1]}${NC}"
cd ${SVN_PROJECTS[$RAND_PROJECT_NUMBER-1]}

echo -e "\n${Green}STEP 4 : LogBot performs an action that generates activity.${NC}"
echo -e "${Cyan}svn update >> $LOGBOT_LOGS_DIR/svn.log 2>&1 ${NC}"

if [ "$TESTING" = false ] ; then
svn update >> $LOGBOT_LOGS_DIR/svn.log 2>&1
fi

# Get ending date
DATE=`date +%d-%m-%Y_%H:%M:%S`
echo -e "\n${Green}LogBot gracefully stopped at${Yellow}" $DATE "${NC}"
