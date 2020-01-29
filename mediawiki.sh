cat << "EOF"
  __  __          _ _                _ _    _      _____             _                   _____
 |  \/  |        | (_)              (_) |  (_)    |  __ \           | |                 / ____|
 | \  / | ___  __| |_  __ ___      ___| | ___     | |  | | ___   ___| | _____ _ __     | |     ___  _ __ ___  _ __   ___  ___  ___
 | |\/| |/ _ \/ _` | |/ _` \ \ /\ / / | |/ / |    | |  | |/ _ \ / __| |/ / _ \ '__|    | |    / _ \| '_ ` _ \| '_ \ / _ \/ __|/ _ \
 | |  | |  __/ (_| | | (_| |\ V  V /| |   <| |    | |__| | (_) | (__|   <  __/ |       | |___| (_) | | | | | | |_) | (_) \__ \  __/
 |_|  |_|\___|\__,_|_|\__,_| \_/\_/ |_|_|\_\_|    |_____/ \___/ \___|_|\_\___|_|        \_____\___/|_| |_| |_| .__/ \___/|___/\___|
                                                                                                             | |
                                                                                                             |_|
EOF

function show_help () {
    echo "Usage: $0 [help] [install] [full-upgrade]"
    cat << "EOF"
  Parameters:
      help: Displays this help message and exits.

      install: Installs the necessary files, starts the service and exits.

      full-upgrade: Deletes the servers and their images, maintaining the data, recreates everything from scratch and exits.

EOF
}

for par in "$@"; do
    case "$par" in
        "help")
            show_help
            exit 0
            ;;
        "install")
            docker-compose up -d
            exit 0
            ;;
        "full-upgrade")
            docker-compose down
            docker network rm mediawiki
            docker rmi mediawiki:1.34
            docker rmi percona:8.0
            docker pull mediawiki:1.34
            docker pull percona:8.0
            docker-compose up -d
            exit 0
            ;;
    esac
done

show_help
