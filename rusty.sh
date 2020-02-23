#!/bin/bash
echo "sup brotato"
#GEORGE_DIR=$(dirname `realpath $(which george)`)

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
			rusty)
				echo "launching Rusty"
				launchRusty
				;;
      build)
        echo "building Rusty"
        buildRusty
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

  # if [[ $(checkRusty ) == 'true' ]]; then
  checkRusty
  if [[ $? -eq 0 ]]; then

    if [[ $(uname) == 'MINGW64_NT-10.0' ]]; then
      windOs='winpty '
    fi
    cd ~/dev
    echo ""
    # /c/Users/Normakster/dev
    local mnt=$(pwd)
    echo $mnt
    ${windOs}docker run \
      --name rusty \
      -it \
      --rm \
      --network rusty-net \
      --dns 8.8.8.8 \
      --privileged \
      --mount "type=bind,src=$(pwd),dst=/deven,ro" \
      -v //var/run/docker.sock:/var/run/docker.sock \
      rusty:latest
      # -v '\Program Files\Git\var\run\docker.sock':/var/run/docker.sock \
     #--mount source=rusty,destination=/
     #-v rusty:/data
     #
     # -v /var/run/docker.sock:/var/run/docker.sock

  fi
}

buildRusty(){
  cd ~/dev/rusty
  docker build --rm -t rusty:latest .
}
#
# launchRusty(){
#   docker run --name rusty -it --rm --mount 'type=bind,src=$(pwd)/..,dst=/dev' rusty:latest
# }

checkRusty(){
  # local good2go=false
  # local success=false

  checkEnv 'docker'

  echo "Checking for Rusty image...."
  #docker images rusty --format "{{.Repository}}:{{.Tag}}"
  local img=($(docker images rusty --format "{{.Repository}}:{{.Tag}}"))
  for i in "${!img[@]}"; do
    echo ${img[i]}
    if [[ ${img[i]} == 'rusty:latest' ]]; then
      echo "--image found-- ${img[i]}"
      return 0
    else
      echo "Do you want to try pulling?"
      ask2proceed
      if [[ $? -eq 0 ]]; then
        echo "pulling...."
        echo "success: $success"
        if [[ "$success" = true ]]; then
          echo '--successful pull'
        #   # good2go=true
          return 0
        fi
      else
        if ls ./rusty/dockerfile 1> /dev/null 2>&1; then
          echo "Do you want to build it?"
          ask2proceed
          if [[ $? -eq 0 ]]; then
            echo "docker build -t rusty -f ./rusty/dockerfile ./rusty"
            $succes=true
            if [[ "$success" = true ]]; then
              echo '--successful build'
            #   # good2go=true
              return 0
            fi
          fi
        else
          echo "Please locate Rusty and try again later."
          return 1
        fi
      fi
    fi
  done
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
