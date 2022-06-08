#!/bin/bash
# InfoG v1.0

###################################################################################################
#                              Check environment, docker list Main function                       #
###################################################################################################

if [ ! -f .env ]; then
        printf "\033[1;91m.env\033[0m file not found. Script terminate \n"
		printf "Or Move .env.example to .env \n"
        exit 0
fi
source .env
if [ ! -d mysql-db/Restore ]; then
	mkdir mysql-db/Restore
fi
#i=0s
###################################################################################################
#                                         Banner                                                  #
###################################################################################################

banner() {
clear
iplist=`hostname -I | grep -Eio "192.168.0.[0-9]+"`
red='\033[1;91m'
NC='\033[0m'
printf "\n"
printf "\e[1;77m   :::::::::::::::::::::::::::::::::::::::::::::::::::::::\e[0m\n"
printf "\e[1;77m      	_    _		.::             .::             \e[0m\e[1;93m.::::    \e[0m\n"
printf "\e[1;77m      _| |__| |_	.::           .:              \e[0m\e[1;93m.:    .::  \e[0m\n"
printf "\e[1;77m     |_        _|	.::.:: .::  .:.: .:   .::    \e[0m\e[1;93m.::         \e[0m\n"
printf "\e[1;77m      _|ADDWEB|_	.:: .::  .::  .::   .::  .:: \e[0m\e[1;93m.::         \e[0m\n"
printf "\e[1;77m     |_   __   _|	.:: .::  .::  .::  .::    .::\e[0m\e[1;93m.::   .:::: \e[0m\n"
printf "\e[1;77m       |_|  |_|		.:: .::  .::  .::   .::  .::  \e[0m\e[1;93m.::    .:  \e[0m\n"
printf "\e[1;77m       		        .::.:::  .::  .::     .::      \e[0m\e[1;93m.:::::    \e[0m\n"
printf "\e[1;77m   ::::::::::::::::::::::::::::::::::::::::::::::::::::::\e[0m\n"
printf "\n"
printf "\e[1;92m            .::.\e[0m\e[1;77m Gathering Tool - v1.0 \e[1;92m.::.\e[0m\n"
printf "\e[1;32m         .::.     Coded by @\033[1;91manish.addweb\033[0m   .::.\e[0m\n"
printf "\n"
echo -e "${red}   System Ip Address:${NC}" $iplist
}

###################################################################################################
#                                           Menu                                                  #
###################################################################################################

menu() {
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m1\e[0m\e[1;92m]\e[1;93m Laravel\e[0m					\e[1;92m[\e[0m\e[1;77m\e[0m7\e[1;92m]\e[1;93m Docker Shell\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m2\e[0m\e[1;92m]\e[1;93m Drupal\e[0m					\e[1;92m[\e[0m\e[1;77m\e[0m8\e[1;92m]\e[1;93m MYSQL Shell\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m3\e[0m\e[1;92m]\e[1;93m Database Backup\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m4\e[0m\e[1;92m]\e[1;93m Database Restore\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m5\e[0m\e[1;92m]\e[1;93m Docker info\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m6\e[0m\e[1;92m]\e[1;93m Project Setup\e[0m\n"
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m0\e[0m\e[1;92m]\e[1;93m \033[1;91mExit\033[0m\e[0m\n"
read -p $'\e[1;92m[*] Choose an option: \e[0m' choice
echo

if ! [[ "$choice" =~ ^[0-9]+$ ]] ; then
	echo "Input Must be Integer"
	menu
else

if   [[ $choice == "0" ]]; then
        exit 0
elif [[ $choice == "1" ]]; then
		dockerMenuSelect="project"
		menuSelect="laravel"
		dock
elif [[ $choice == "2" ]]; then
		dockerMenuSelect="project"
		menuSelect="drupal"
		dock
elif [[ $choice == "3" ]]; then
		dbbackup
elif [[ $choice == "4" ]]; then
		dbrestore
elif [[ $choice == "5" ]]; then
		dockerInfo
elif [[ $choice == "6" ]]; then
		dockerMenuSelect="createProject"
		dock
elif [[ $choice == "7" ]]; then
		dockerMenuSelect="shell"
		dock
elif [[ $choice == "8" ]]; then
		dockerMenuSelect="dbshell"
		dock
else

	printf "\n\e[1;43m[!] Invalid option!\e[0m\n\n"
	menu
fi

fi

}

###################################################################################################
#                                        Docker Module                                            #
###################################################################################################

dock() {

# Docker List
dnamelist=`docker ps | awk '{print $NF}'| tail -n +2 | nl`
#dnamelistCount=`docker ps | awk '{print $NF}'| tail -n +2 | nl | wc -l`
dname=`docker ps | awk '{print $NF}'| tail -n +2`
dnamelistCount=`echo $dname | wc -w`

dockerName=$DOCKER_DEFAULT_NAME     						#default docker Image name

if [[ $dockerMenuSelect == "project" ]]; then
		dockerUse=Project
elif [[ $dockerMenuSelect == "shell" ]]; then
		dockerUse=dockerShell
elif [[ $dockerMenuSelect == "dbshell" ]]; then
		dockerName=$DBDOCKER_DEFAULT_NAME
		dockerUse=databaseShell
elif [[ $dockerMenuSelect == "createProject" ]]; then
		dockerName=$DOCKER_DEFAULT_NAME
		dockerUse=createProject
else
	echo "Invalid"
fi

######################################
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Select Docker Image Name\e[0m\n"
printf "\n"
printf "\e[1;92m\e[1;93m%s \e[0m\n" "$dnamelist"
printf "\n"
printf "\e[1;92m\e[1;93mDefalut '$dockerName' \e[0m\n"
#printf "\n"
read  -p $'\e[1;92m[*] Use default press \033[1;91mEnter\033[0m \e[1;92mor else select container : \e[0m' choice

# Project Docker Image Select
if [ ! -z $choice ]; then

	if [ $choice -le $dnamelistCount ]; then
		dockerName=`echo  $dname | awk 'NR==1 {print $'$choice'}'`
		$dockerUse
	else
		printf "\n\e[1;43m[!] Invalid option!\e[0m\n\n"
		dock
	fi
else
	$dockerUse
fi

}

Project() {

## variable
#

if  [[ $menuSelect == "laravel" ]]; then
		dirProj=$LARAVEL_DIR
		dockerDirPath="/var/www/html/$dirProj"
elif [[ $menuSelect == "drupal" ]]; then
		dirProj=$DRUPAL_DIR	
		dockerDirPath="/var/www/html/$dirProj"
fi

IP=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $dockerName`

if [[ -z "$DEFAULT_DIRECTORY" ]]; then

projectList=`docker exec -i $dockerName bash -c "ls $dockerDirPath" | nl`
projectListSelect=`docker exec -i $dockerName bash -c "ls $dockerDirPath"`
projectListCount=`echo $projectListSelect | wc -w`


####################################
clear
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Project List \e[0m\n"
printf "\n"
printf "\e[1;92m\e[1;93m%s \e[0m\n" "$projectList"
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m0\e[0m\e[1;92m]\e[1;93m to main menu \e[0m\n"
read -p $'\e[1;92m[*] Choose an option: \e[0m' choice

# Selecting Project list

	if [ ! -z $choice ]; then

		if [[ $choice == "0" ]]; then
				clear
				menu
		elif [ $choice -le  $projectListCount ]; then
                projName=`echo  $projectListSelect | awk 'NR==1 {print $'$choice'}'`
                dockerDirPath="$dockerDirPath/$projName"
                $menuSelect
		else
                printf "\n\e[1;43m[!] Invalid option!\e[0m\n\n"
                Project
        fi

	else
		Project
	fi

else
	dockerDirPath=$DEFAULT_DIRECTORY
	$menuSelect
fi
}

###################################################################################################
#                                       Laravel Module                                            #
###################################################################################################

laravel() {
####command
clear
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Laravel Command List \033[1;91m$projName\033[0m \e[0m\n"
printf "\n"
printf "	\e[1;92m[\e[0m\e[1;77m1\e[0m\e[1;92m]\e[1;93m artisan serve \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m2\e[0m\e[1;92m]\e[1;93m artisan config:cache \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m3\e[0m\e[1;92m]\e[1;93m artisan cache:clear \e[0m\n"
printf "\n"
printf "	\e[1;92m[\e[0m\e[1;77m4\e[0m\e[1;92m]\e[1;93m composer require \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m5\e[0m\e[1;92m]\e[1;93m composer install \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m6\e[0m\e[1;92m]\e[1;93m composer update \e[0m\n"
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m0\e[0m\e[1;92m]\e[1;93m to Main Menu \e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m#\e[0m\e[1;92m]\e[1;93m to Select Other Project \e[0m\n"
read  -p $'\e[1;92m[*] Choose an option: \e[0m' choice
echo

defPort="8005"

if [[ $choice == "1" ]]; then
	printf "\n"
	read -N4 -p $'\e[1;92m[*] Enter Artisian serve port[default:8000]: \e[0m' choice
	echo
	if [ ! -z $choice ]; then
		defPort=$choice
	fi
	docker exec -i $dockerName bash -c "cd $dockerDirPath && php artisan serve --host=$IP --port=$defPort"
	sleep 2
elif [[ $choice == "2" ]]; then
	docker exec -i $dockerName bash -c "cd $dockerDirPath && php artisan config:cache"

elif [[ $choice == "3" ]]; then
        docker exec -i $dockerName bash -c "cd $dockerDirPath && php artisan cache:clear"

elif [[ $choice == "4" ]]; then
        printf "\n"
        read  -p $'\e[1;92m[*] Enter Composer Package Name: \e[0m' choice
        if [ ! -z $choice ]; then
                package=$choice
        fi
        docker exec -i $dockerName bash -c "cd $dockerDirPath && composer require $package"
elif [[ $choice == "5" ]]; then
        docker exec -i $dockerName bash -c "cd $dockerDirPath && composer install"

elif [[ $choice == "6" ]]; then
        docker exec -i $dockerName bash -c "cd $dockerDirPath && composer update"

elif [[ $choice == "0" ]]; then
	clear
	menu
elif [[ $choice == "#" ]]; then
        clear
        Project
else

	printf "\n\e[1;43m[!] Invalid option!\e[0m\n\n"
	sleep 1
	laravel
fi
sleep 2
laravel
}

###################################################################################################
#                                      Drupal Module                                              #
###################################################################################################

drupal() {
####command
#clear
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Drupal Command List for \033[1;91m$projName\033[0m \e[0m\n"
printf "\n"
printf "	\e[1;92m[\e[0m\e[1;77m1\e[0m\e[1;92m]\e[1;93m Drush status \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m2\e[0m\e[1;92m]\e[1;93m Drush cr \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m3\e[0m\e[1;92m]\e[1;93m Drush updb \e[0m\n"
printf "\n"
printf "	\e[1;92m[\e[0m\e[1;77m4\e[0m\e[1;92m]\e[1;93m composer require \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m5\e[0m\e[1;92m]\e[1;93m composer install \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m6\e[0m\e[1;92m]\e[1;93m composer update \e[0m\n"
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m0\e[0m\e[1;92m]\e[1;93m to Main Menu \e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m#\e[0m\e[1;92m]\e[1;93m to Select Other Project \e[0m\n"
read -p $'\e[1;92m[*] Choose an option: \e[0m' choice
echo

if [[ $choice == "1" ]]; then
	docker exec -i $dockerName bash -c "cd $dockerDirPath && drush status"

elif [[ $choice == "2" ]]; then
	docker exec -i $dockerName bash -c "cd $dockerDirPath && drush cr"

elif [[ $choice == "3" ]]; then
        docker exec -i $dockerName bash -c "cd $dockerDirPath && drush updb"

elif [[ $choice == "4" ]]; then
        printf "\n"
        read  -p $'\e[1;92m[*] Enter Composer Package Name: \e[0m' choice
        if [ ! -z $choice ]; then
                package=$choice
        fi
        docker exec -i $dockerName bash -c "cd $dockerDirPath && composer require $package"
elif [[ $choice == "5" ]]; then
        docker exec -i $dockerName bash -c "cd $dockerDirPath && composer install"

elif [[ $choice == "6" ]]; then
        docker exec -i $dockerName bash -c "cd $dockerDirPath && composer update"

elif [[ $choice == "0" ]]; then
	clear
	menu
elif [[ $choice == "#" ]]; then
        clear
        Project
else

	printf "\n\e[1;43m[!] Invalid option!\e[0m\n\n"
	sleep 1
	drupal
fi
sleep 2
drupal
}

###################################################################################################
#                                         Database Backup                                         #
###################################################################################################

dbbackup() {

# variable
dbdefault=$DBDOCKER_DEFAULT_NAME
dockerDBList=`docker exec -i $dbdefault bash -c "mysql -u $MYSQL_USER -p$MYSQL_PASS -e 'show databases;'" | nl`
dockerDB=`docker exec -i $dbdefault bash -c "mysql -u $MYSQL_USER -p$MYSQL_PASS -e 'show databases;'"`
dockerdbCount=`echo $dockerDB | wc -w`
date=`date +%H:%M,%d_%m_%Y`

# Creating backup directory

if [ ! -d mysql-db/Backup ]; then
	mkdir -p mysql-db/Backup
fi

# database entry in list
clear
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Database List \e[0m\n"
printf "\n"
printf "\e[1;92m\e[1;93m%s \e[0m\n" "$dockerDBList"
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m0\e[0m\e[1;92m]\e[1;93m to Main Menu \e[0m\n"
read -p $'\e[1;92m[*] Choose an option: \e[0m' choice
# Project Docker Image Select
if [ ! -z $choice ]; then


	if [ $choice -eq 0 ]; then
			clear
			menu
	elif [ $choice -le $dockerdbCount ]; then
		dbSelect=`echo  $dockerDB | awk 'NR==1 {print $'$choice'}'`

		# creating project dir
		if [ ! -d mysql-db/Backup/$dbSelect ]; then
			mkdir mysql-db/Backup/$dbSelect
		fi

		printf "\e[1;92m\e[1;93m%sBackuping mysql database \033[1;91m$dbSelect\033[0m \e[0m\n" 
		docker exec  "$dbdefault" mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASS" "$dbSelect" | grep -v 'mysqldump: \[Warning\]' > mysql-db/Backup/$dbSelect/"$dbSelect"_"$date".sql
		printf "\e[1;92m\e[1;93m%sBackup store at: \033[1;91m$(pwd)/mysql-db/Backup/$dbSelect/"$dbSelect"_"$date".sql\033[0m \e[0m\n"
		sleep 3
	else
		printf "\n\e[1;43m[!] Invalid option!\e[0m\n\n"
		dbbackup
	fi
else
	dbbackup
fi
clear
menu
}

###################################################################################################
#                                       Database Restore                                          #
###################################################################################################

dbrestore() {

dbRestoreList=`ls mysql-db/Restore | nl`
dbList=`ls mysql-db/Restore`
dbRestoreListCount=`ls mysql-db/Restore | wc -w`

dbdefault=$DBDOCKER_DEFAULT_NAME
echo "db name" $dbdefault
dockerDBList=`docker exec -i $dbdefault bash -c "mysql -u $MYSQL_USER -p$MYSQL_PASS -e 'show databases;'" | nl`
dockerDB=`docker exec -i $dbdefault bash -c "mysql -u $MYSQL_USER -p$MYSQL_PASS -e 'show databases;'"`
dockerdbCount=`echo $dockerDB | wc -w`

clear
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Database Import List \e[0m\n"
printf "\n"
printf "\e[1;92m\e[1;93m%s \e[0m\n" "$dbRestoreList"
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m0\e[0m\e[1;92m]\e[1;93m to Main Menu \e[0m\n"
read -p $'\e[1;92m[*] Choose an option: \e[0m' choice

if [ ! -z $choice ]; then

	if [ $choice -eq 0 ]; then
			clear
			menu
	elif [ $choice -le $dbRestoreListCount ]; then
		dbSelect=`echo  $dbList | awk 'NR==1 {print $'$choice'}'`
	else
		printf "\n\e[1;43m[!] Invalid option!\e[0m\n\n"
		dbrestore
	fi
else
	dbrestore
fi

clear
printf "\n"
printf "	\e[1;92m[\e[0m\e[1;77m1\e[0m\e[1;92m]\e[1;93m Create New Database \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m2\e[0m\e[1;92m]\e[1;93m Use Existing Database \e[0m\n"
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m0\e[0m\e[1;92m]\e[1;93m to Main Menu \e[0m\n"
read -p $'\e[1;92m[*] Choose an option: \e[0m' choice
if [ $choice -eq 0 ];  then
		clear
		menu
elif [ $choice -eq 1 ]; then
		dbCreate
elif [ $choice -eq 2 ]; then
		dbExist
else
dbCondition
fi

}

dbCreate() {

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Enter Database Name \e[0m\n"
read -p $'\e[1;92m> \e[0m' choice
grep "$choice" <<< $dockerDB 
# echo $?
if [ $? -eq 0 ]; then
	printf "\n"
	printf "\e[1;92m\e[1;91mDatabase already exist. Use different keyword. \e[0m\n"
	sleep 3
	dbCreate
else
	docker exec -i $dbdefault bash -c "mysql -u $MYSQL_USER -p$MYSQL_PASS -e 'create database $choice;'"
	cat mysql-db/Restore/$dbSelect | docker exec -i $dbdefault bash -c "mysql -u $MYSQL_USER -p$MYSQL_PASS $choice"
	printf "\e[1;92m\e[1;93m[*] $dbSelect Database Successfully Imported in $choice. \e[0m\n"
	sleep 3
	menu
fi

}

dbExist() {

clear
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Database List \e[0m\n"
printf "\n"
printf "\e[1;92m\e[1;93m%s \e[0m\n" "$dockerDBList"
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m0\e[0m\e[1;92m]\e[1;93m to Main Menu \e[0m\n"
read -p $'\e[1;92m[*] Choose an option: \e[0m' choice

if [ ! -z $choice ]; then

	if [ $choice -eq 0 ]; then
			clear
			menu
	elif [ $choice -le $dockerdbCount ]; then
		dbList=`echo  $dockerDB | awk 'NR==1 {print $'$choice'}'`

		cat mysql-db/Restore/$dbSelect | docker exec -i $dbdefault bash -c "mysql -u $MYSQL_USER -p$MYSQL_PASS $dbList"
		#printf "\e[1;92m\e[1;93m[*] $dbSelect Database Successfully Imported in $choice. \e[0m\n"
		sleep 3
		menu
	else
		printf "\n\e[1;43m[!] Invalid option!\e[0m\n\n"
		dbExist
	fi
else
	dbExist
fi
clear
menu

}

###################################################################################################
#                                         Docker shell                                            #
###################################################################################################

dockerShell() {
echo
docker exec -it $dockerName bash
clear
menu
}

databaseShell() {
echo
docker exec -it $dockerName bash -c "mysql -u $MYSQL_USER -p$MYSQL_PASS"
clear
menu
}

###################################################################################################
#                                         Create Project                                          #
###################################################################################################

createProject() {

clear
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Project Type note: Project creates using .env file environment \e[0m\n"
printf "\n"
printf "	\e[1;92m[\e[0m\e[1;77m1\e[0m\e[1;92m]\e[1;93m Laravel \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m2\e[0m\e[1;92m]\e[1;93m Drupal \e[0m\n"
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m0\e[0m\e[1;92m]\e[1;93m to Main Menu \e[0m\n"
read -p $'\e[1;92m[*] Choose an option: \e[0m' choice
if [ $choice -eq 0 ];  then
		clear
		menu
elif [ $choice -eq 1 ]; then
		laravelProjectCreate
elif [ $choice -eq 2 ]; then
		drupalProjectCreate
else
printf "	\e[1;92m[\e[0m\e[1;77m1\e[0m\e[1;92m]\e[1;93m Invalid Option \e[0m\n"
createProject
fi
}

laravelProjectCreate() {

dirProj=$LARAVEL_DIR
dockerDirPath="web/$dirProj"
listLaravelProject=`ls web/public/`
clear
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Enter Project Name note: Project creates using .env file environment \e[0m\n"
printf "\n"
read -p $'\e[1;92m> \e[0m' choice
grep $choice <<< $listLaravelProject
if [ $? -eq 0 ]; then
	printf "\n"
	printf "\e[1;92m\e[1;91mProject already exist. Use different keyword. \e[0m\n"
	sleep 3
	laravelProjectCreate
else
	docker exec -it $dockerName bash -c "cd /var/www/html/$dirProj && laravel new $choice"
	printf "\n"
	printf "\e[1;92m\e[1;93m[*] $choice Project Successfully Created. \e[0m\n"
	sleep 3
	menu
fi
}

drupalProjectCreate() {

dirProj=$DRUPAL_DIR
dockerDirPath="web/$dirProj"
listLaravelProject=`ls web/public/`
clear
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Enter Project Name note: Project creates using .env file environment \e[0m\n"
printf "\n"
read -p $'\e[1;92m> \e[0m' choice
grep $choice <<< $listLaravelProject
if [ $? -eq 0 ]; then
	printf "\n"
	printf "\e[1;92m\e[1;91mProject already exist. Use different keyword. \e[0m\n"
	sleep 3
	laravelProjectCreate
else
	docker exec -it $dockerName bash -c "cd /var/www/html/$dirProj && composer create-project drupal-composer/drupal-project:8.x-dev $choice --stability dev --no-interaction"
	printf "\n"
	printf "\e[1;92m\e[1;93m[*] $choice Project Successfully Created. \e[0m\n"
	sleep 3
	menu
fi
}

###################################################################################################
#                                         Create Project                                          #
###################################################################################################
dockerInfo() {

clear
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m]\e[1;93m Docker Commands \e[0m\n"
printf "\n"
printf "	\e[1;92m[\e[0m\e[1;77m1\e[0m\e[1;92m]\e[1;93m Start Docker \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m2\e[0m\e[1;92m]\e[1;93m Stop Docker \e[0m\n"
printf "	\e[1;92m[\e[0m\e[1;77m3\e[0m\e[1;92m]\e[1;93m Down Docker \e[0m\n"
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m0\e[0m\e[1;92m]\e[1;93m to Main Menu \e[0m\n"
read -p $'\e[1;92m[*] Choose an option: \e[0m' choice
if [ $choice -eq 0 ];  then
		clear
		menu
elif [ $choice -eq 1 ]; then
		docker-compose up -d
elif [ $choice -eq 2 ]; then
		docker-compose stop
elif [ $choice -eq 3 ]; then
		docker-compose down
else
printf "	\e[1;92m[\e[0m\e[1;77m1\e[0m\e[1;92m]\e[1;93m Invalid Option \e[0m\n"
dockerInfo
fi


}
###################################################################################################
# Main function
banner
menu
