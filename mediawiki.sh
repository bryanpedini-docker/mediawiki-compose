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
    echo "Usage: $0 [help] <install | start | stop | full-upgrade | uninstall>"
    cat << "EOF"
  Parameters:
      help: Displays this help message and exits.

      install: Installs the necessary files, starts the service and exits.

      start: Starts the servers, brings the service online and exits.

      stop: Brings the service offline, stops the servers gracefully and exits.

      full-upgrade: Deletes the servers and their images, maintaining the data, recreates everything from scratch and exits.

      uninstall: Deletes the servers and their images, and all the data if necessary and exits.

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
        "start")
            docker-compose start -d
            exit 0
            ;;
        "stop")
            docker-compose stop
            exit 0
            ;;
        "full-upgrade")
            docker-compose down
            docker network rm mediawiki
            docker rmi mediawiki:1.34
            docker pull mediawiki:1.34
            docker-compose up -d
            exit 0
            ;;
        "uninstall")
            docker-compose down
            docker rmi mediawiki:1.34
            read -p "Do you also whish to delete all the data stored in the database (requires sudo permission)? <y | n> [n]" DELETE_DATA
            case "$DELETE_DATA" in
                "y" | "Y")
                    sudo rm -rf data/db/* -v ".gitignore"
                    ;;
                *)
                    exit 0
                    ;;
            esac
            exit 0
            ;;
    esac
done

show_help
