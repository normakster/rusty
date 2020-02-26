#!/bin/bash
# set -e # Script exists on first failure
# set -x # For debugging purpose
echo "sup brotato"

#gits=('')
utils=('docker' 'python' 'git' 'aws' 'rsync' 'curl')
utilsPoss=('node' 'vim' 'htop' )

parse() {
	# for arg in $*; do
		# echo $arg
    local arg=$1
		# case ${arg[0]} in
		case ${arg[0]} in
			checks)
				echo "checking environment"
				checkEnv ${utils[@]}
				;;
			# check)
			# 	echo "checking ${arg[1]}"
			# 	checks ${arg[1]}
			# 	;;
			aws)
				echo "launching aws"
				AWS
				;;
			launch)
				echo "launching Rusty"
				launchRusty
				;;
			backup)
				echo "what to backup?"
				read in
				backup
				;;
			basheval)
				echo "what to basheval?"
				read in
				basheval $in
				;;
			cli)
				echo "starting cli"
				cli
				;;
			initLinux)
				echo "initing new linux installation"
				initLinux
				;;
			install)
				echo "installing latest "
				read in
				install $in
				;;
			dockercompose)
				echo "installing docker-compose"
				dockercompose
				;;
			exit)
				exit 1
		esac
	# done
}

cli() {
	while true; do
    echo "----------------"
		echo "yes?"
		read -a ans
		parse $ans
	done
}

ask2proceed(){
  local proceed=false
  read -a ans
  if [[ $ans == "Y" || $ans == "Yes" || $ans == "y" || $ans == "yes" ]]; then
    return 0
  else
    return 1
  fi
}

backup(){
	#Back up docker images
	# SYNTAX backup docker <image/volume> <image-name>
	local args=$*
	case ${args[0]} in
		rusty)
			echo "Backing up Rusty"
			;;
		docker)
			echo "Image or Volume AND it's name?"
			local line
			read -a line
			case ${ling[0]} in
				image)
					echo "backing up image ${ling[1]}"
					;;
				volume)
					echo "backing up volume ${ling[1]}"
					;;
				exit)
					exit 1
			esac
      ;;
		repo)
			echo "Backing up ____"
			;;
		git)
			echo "Backing up ____"
			;;
		exit)
			exit 1
	esac
}

AWS(){
	echo 'Connector to AWS'
}

DOCKER(){
  echo 'Backup, etc.'
}

launchRusty(){

  checkRusty
  if [[ $? -eq 0 ]]; then

    if [[ $(uname) == 'MINGW64_NT-10.0' ]]; then
      windOs='winpty '
    fi
    # echo ""
    # echo $(pwd)
    # echo ""
    cd ..
    # echo $(pwd)
    #echo "press enter to continue" && read -a line

    local containers=($(docker ps -a --format "{{.Names}}"))
    declare -A map    # required: declare explicit associative array
    for key in "${!containers[@]}"; do map[${containers[$key]}]="$key"; done
    if [[ -n "${map[rusty]}" ]]; then
      echo "starting stopped container : "
      ${windOs}make -f ./rusty/makefile login
    else
      echo "running fresh : "${ctnr[i]}
      ${windOs}make -f ./rusty/makefile run
    fi
    echo "press enter to continue" && read -a line
  fi
}

buildRusty(){
  docker build --rm -t rusty:latest .
}

checkRusty(){
  # local good2go=false
  # local success=false

  checkEnv 'docker'

  echo "Checking for Rusty image...."
  #docker images rusty --format "{{.Repository}}:{{.Tag}}"
  local img=($(docker images rusty --format "{{.Repository}}:{{.Tag}}"))
  echo ${!img[@]}

  for i in "${!img[@]}"; do
    echo ${img[i]}
    if [[ ${img[i]} == 'rusty:latest' ]]; then
      echo "--image found-- ${img[i]}"
      return 0
    fi
  done

  echo "Do you want to try pulling?"
  ask2proceed
  if [[ $? -eq 0 ]]; then
    echo "pulling...."
    #success="true"
    if [[ "$success" = "true" ]]; then
      echo '--successful pull'
    #   # good2go=true
      return 0
    else
      echo 'failed to pull: no image found.'
    fi
  fi
  echo "Do you want to try building?"
  ask2proceed
  if [[ $? -eq 0 ]]; then
    make build
    success="true"
    if [[ "$success" = "true" ]]; then
      echo '--successful build'
    #   # good2go=true
      return 0
    else
      echo 'failed to build.'
    fi
  fi
  echo "press enter to continue" && read -a line

}

checkEnv(){
  # Check for installs
  local arr=("$@")
  for arg in ${arr[@]}; do
    echo "Checking $arg"
    if [[ $(which "$arg") && $($arg --version) ]]; then
        echo "$arg is installed"
        $arg --version
      else
        echo "Do you want to install $arg?"
        ask2proceed
        if [[ $? -eq 0 ]]; then
          install $arg
        else
          echo "Skipping install of $arg"
        fi
    fi
  done
}

install(){

  case $1 in
    docker)
      echo "starting to install Docker"
      sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      sudo apt-get update
      sudo apt-get install docker-ce docker-ce-cli containerd.io
      echo "sucessfully installed docker! Remember to log out and log in before using it the first time!"
      ;;
    node)
      echo "starting to install Node"
      curl -sL https://deb.nodesource.com/setup_10.15.1 | bash -
      apt-get install -y nodejs
      echo "sucessfully installed Node!"
      ;;
    exit)
      exit 1
  esac
}

basheval(){
	for i in $*; do
		eval $i
	done
}

# parse $*
parse $1
