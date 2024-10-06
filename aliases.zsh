#
# Miscellaneous
#
alias o='open'
alias cpr='cp -r'
alias rr='rm -r'
alias lr="ls -alR"

#
# Network
#
alias cleardns='dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

#
# Package managers
#
alias composer_install_fresh='rm -rf vendor/ composer.lock && composer install'
alias npm_install_fresh='rm -rf node_modules/ package-lock.json && npm install'

#
# Docker
#
alias dce='docker compose exec'
alias dcl='docker compose logs -f'
alias dcr='docker compose run --rm'
alias dcp='docker compose ps --all'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcs='docker compose start && dcp'
alias dcsps='docker compose stop'
alias dcsp='dcsps && dcp'
alias dcre='docker compose restart && dcp'
alias dcdu='dcd && dcu && dcp'
alias dcb='docker compose down && docker compose up -d --remove-orphans --build && dcp'
alias dcbr='docker compose down && docker compose rm --force && docker compose up -d --remove-orphans --build && dcp'
alias dcbf='docker compose down && docker compose rm --force && docker compose up -d --remove-orphans --build --force-recreate && docker compose ps'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias ds='docker stop $(docker ps -q)'
alias dst='docker stats $(docker inspect -f "{{ .Name }}" $(docker ps -q))'

# Removes unused/dead containers, images, and volumes
function docker-cleanup-unused() {
    docker ps --filter status=dead --filter status=exited -aq | xargs docker rm -v
    docker images -q --filter dangling=true | xargs docker rmi
    docker volume rm $(docker volume ls -qf dangling=true)
}

# Removes all Docker data
function docker-cleanup-all() {
    docker system prune --all --volumes --force
}

#
# Git
#
alias yolo='git commit -m "$(curl -s http://whatthecommit.com/index.txt)"'

# Displays drives and space in human readable format
alias dfh='df -h'

# Stops ping after sending 4 ECHO_REQUEST packets
alias ping10='ping -c 10'

# Lists directories only, in long format
alias lsd='ls -l | grep --color=never "^d"'

# Lists hidden files in long format
alias lsh='ls -dlA .?*'

# Clears the console screen
alias c='clear'

#
# Editors
#
alias e='o -a Sublime\ Text'
alias v='o -a MacVim'
alias vi='vim'
alias svi='sudo vi'
alias se='sudo open -a Sublime\ Text'
alias sv='sudo open -a MacVim'

# Local/UTC date and time in ISO-8601 format `YYYY-MM-DDThh:mm:ss`
alias now='date +"%Y-%m-%dT%H:%M:%S"'
alias unow='date -u +"%Y-%m-%dT%H:%M:%S"'

# Date in `YYYY-MM-DD` format
alias nowdate='date +"%Y-%m-%d"'
alias unowdate='date -u +"%Y-%m-%d"'

# Time in `hh:mm:ss` format
alias nowtime='date +"%T"'
alias unowtime='date -u +"%T"'

# Unix time stamp
alias timestamp='date -u +%s'

# External IP address
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
#alias ip='curl ipinfo.io/ip'

# Prints each $PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Displays information about the system
for command in winfetch fastfetch screenfetch; do
    if type $command &> /dev/null; then
        alias sysinfo='$command'
        break
    fi
done

#
# Web browsers, e.g. opens file/URL in a particular browser
#
alias chrome='open -a Google\ Chrome'
alias edge='open -a Microsoft\ Edge'
alias firefox='open -a Firefox'
alias opera='open -a Opera'
alias safari='open -a Safari'

#
# Speedtest
#
alias st='speedtest-cli --secure'
alias sts='speedtest-cli --secure --simple'

# Toggles display of desktop icons
alias hide_desktop_icons='defaults write com.apple.finder CreateDesktop -bool false && killall Finder'
alias show_desktop_icons='defaults write com.apple.finder CreateDesktop -bool true && killall Finder'

# Toggles hidden files in Finder
alias hide_hidden_files='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias show_hidden_files='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'

# Toggles Spotlight
alias spotlight_off='sudo mdutil -a -i off'
alias spotlight_on='sudo mdutil -a -i on'

# Locks the session
alias lock='pmset displaysleepnow'

# Hibernates the system
alias hibernate='pmset sleepnow'

# Restarts the system
alias reboot='osascript -e "tell application \"System Events\" to restart"'

# Shuts down the system
alias poweroff='osascript -e "tell application \"System Events\" to shut down"'

# Detailed weather and forecast
if command -v curl > /dev/null; then
    alias forecast='curl --silent --compressed --max-time 10 --url "https://wttr.in?F"'
else
    alias forecast='wget -qO- --compression=auto --timeout=10 "https://wttr.in?F"'
fi

# Current weather
if command -v curl > /dev/null; then
    alias weather='curl --silent --compressed --max-time 10 --url "https://wttr.in/?format=%l:+(%C)+%c++%t+\[%h,+%w\]"'
else
    alias weather='wget -qO- --compression=auto --timeout=10 "https://wttr.in/?format=%l:+(%C)+%c++%t+\[%h,+%w\]"'
fi

# Keeps all apps and packages up to date.
# Syntax: `update [all]`
function update() {
    if command -v softwarepudate &> /dev/null; then
        echo 'Checking for system updates...'
        softwareupdate -l -i -a
    fi

    if command -v brew &> /dev/null; then
        echo 'Updating packages with Homebrew/Linuxbrew...'
        brew update
        brew upgrade
        brew cleanup
    fi

    if [[ "$1" == 'all' ]]; then
        if command -v mas &> /dev/null; then
            echo 'Updating App Store applications...'
            mas upgrade
        fi
    fi

    if ! [[ "$OSTYPE" =~ ^darwin ]]; then
        if command -v apt &> /dev/null; then
            echo 'Updating packages with apt...'
            apt update
            apt full-upgrade
            apt autoremove
            apt clean
            apt autoclean
        fi

        if command -v apt-get &> /dev/null; then
            echo 'Updating packages with apt-get...'
            apt-get update
            apt-get upgrade
            apt-get dist-upgrade
        fi
    fi

    if command -v npm &> /dev/null; then
        echo 'Updating Node.js packages with npm...'
        which npm
        npm update -g
    fi

    if command -v npm &> /dev/null; then
        echo 'Updating Ruby gems...'
        which gem
        gem update --system
        gem update
        gem cleanup
    fi

    if command -v omz &> /dev/null; then
        echo 'Updating Oh My Zsh...'
        omz update
        omz reload
    fi
}

# Creates a directory and changes to it.
# Syntax: `mkcd <directory>`
function mkcd() {
    if [ -z "$1" ]; then
        echo "Usage: mkcd <path>"
        echo "Help: mkcd creates a directory if it doesn't exist, then changes to it."
        return 0
    fi

    mkdir -p -- "$@" && cd -P -- "$_" || exit;
}
alias take=mkcd
