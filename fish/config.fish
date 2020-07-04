# Install fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end
set -g ASCII_DIR (realpath ~/asciiArt)
# bob the fish stuff
source ~/.config/fish/config/bobTheFish.fish

#aliases
source ~/.config/fish/aliases.fish

# Load additional config based on hostname
set host_config ~/.config/fish/config.(hostname).fish
test -r $host_config; and source $host_config

if [ $PWD = (realpath ~) ]; randomAsciiImage; end