function mkvenv() {
    if [[ -z "$1" ]]; then
        DIR="venv"
    else
        DIR=$1
    fi

    if [[ -d $DIR ]]; then
        echo "Remove existing virtual environment? (y/n)"
        read removeExisting
        if [[ $removeExisting == "y" || $removeExisting == "Y" ]]; then
            rm -rf $DIR
        else
            return 0
        fi
    fi

    # make a new virtual environment with the desired directory name
    python3 -m venv ./$DIR

    # create .envrc if it isn't already there
    touch .envrc
    cat .envrc | grep "source $DIR/bin/activate" > /dev/null || echo "source $DIR/bin/activate" >> .envrc

    touch .gitignore
    cat .gitignore | grep .envrc > /dev/null || echo .envrc >> .gitignore
    cat .gitignore | grep $DIR > /dev/null || echo "$DIR/" >> .gitignore

    type direnv > /dev/null && direnv allow
}

function weather() {
    curl wttr.in/$1
}

function config() {
    # navigate to the config file for a specific app
    cd "$XDG_CONFIG_HOME/$1" || echo "$1 is not a valid config directory."
}

function service() {
    if [[ -z "$1" ]] then
        echo "no command provided from [stop, start, restart]"
        return 1
    fi
    if [[ -z "$2" ]]; then
        echo "No service name provided"
        return 1
    fi

    service=$(launchctl list | awk "/$2/ {print $NF}")
    if [[ "$1" == "restart" ]]; then
        launchctl stop $service && launchctl start $service
    else
        launchctl $1 $service
    fi
}

function rebuildFlake() {
    command -v darwin-rebuild > /dev/null && darwin-rebuild switch --flake "$HOME/.nixpkgs/#$1" || true
    command -v nixos-rebuild > /dev/null && sudo nixos-rebuild switch --flake "/etc/nixos/#$1" || true
}

function gi() {
    curl -sL "https://www.toptal.com/developers/gitignore/api/$@";
}
