
parse() {
	# for arg in $*; do
		# echo $arg
    local arg=$1
		# case ${arg[0]} in
		case ${arg[0]} in
      initLinux)
        echo "initing new linux installation"
        initLinux
        ;;
			install)
				echo "installing latest "
				read in
				install $in
				;;
			backup)
				echo "what to backup?"
				read in
				backup
				;;
			aws)
				echo "launching aws"
				AWS
				;;
			dockercompose)
				echo "installing docker-compose"
				dockercompose
				;;
			# check)
			# 	echo "checking ${arg[1]}"
			# 	checks ${arg[1]}
			# 	;;
			exit)
				exit 1
		esac
	# done
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

buildRusty(){
  docker build --rm -t rusty:latest .
}

DOCKER(){
  echo 'Backup, etc.'
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
