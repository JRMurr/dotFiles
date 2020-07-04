if type -q nvm
    nvm use 10
end
sudo ifconfig lo0 alias 10.0.2.2

# bob the fish stuff
source ~/.config/fish/config/bobTheFish.fish


alias cat="bat -p --paging=never"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/jmurray/opt/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# immuta libhdfs stuff
# set -g fish_user_paths "/usr/local/opt/icu4c/bin" $fish_user_paths
# set -g fish_user_paths "/usr/local/opt/icu4c/sbin" $fish_user_paths
# set -gx LDFLAGS "-L/usr/local/opt/krb5/lib"
# set -gx CPPFLAGS "-I/usr/local/opt/krb5/include"nvm use 10
# set -x DYLD_LIBRARY_PATH /usr/local/lib $DYLD_LIBRARY_PATH



alias cleanGit="git branch --merged | egrep -v '(^\*|master|dev)' | xargs git branch -d"
alias cleanSquash="git-delete-squashed"
alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias cleanDocker="bash ~/scripts/cleanDocker.sh"
alias sshAm="ssh -i ~/personal/jr.pem ec2-user@ec2-35-170-192-165.compute-1.amazonaws.com"
alias gitSyncUp="git fetch upstream; git rebase upstream/master"
alias jsonJs="pbpaste | json-to-js --spaces=4 | pbcopy; pbpaste"
alias lzd='lazydocker'


#immuta
alias sshB="ssh -A -l jmurray bastion.immuta.com"
alias gUnit="grunt mocha_istanbul:unit"
alias buildPost="bash ~/scripts/buildBodataPost.sh"
alias buildDevPost="bash ~/scripts/buildDevPost.sh"
alias buildFinger="bash ~/scripts/buildFingerPrint.sh"
alias bocode="code ~/immuta/bodata"
alias pgKris="psql -d immuta -U kris -h localhost"
alias pgJeff="psql -d immuta -U jeff -h localhost"
alias cliKris="pgcli postgresql://kris:pass@db.immuta:5432/immuta"
alias cliJeff="pgcli \"postgresql://jeff:pass@db.immuta:5432/immuta?sslmode=require\""
alias devBash="docker exec -i -t immuta-db-dev /bin/bash"
alias devPost="docker exec -i -t immuta-db-dev psql -d bometadata -U bometa"
alias dockerBash="docker exec -i -t bodata_postgres /bin/bash"
alias postLogs="docker logs bodata_postgres -f"
alias devLogs="docker logs immuta-db-dev -f"
alias dockerPost="docker exec -i -t bodata_postgres psql -d bometadata -U bometa"
alias pgBo="pgcli postgresql://bometa:secret@localhost:5432/bometadata"
alias pgFe=" psql postgresql://feature_service:secret@localhost:5432/immuta"
alias buildRun="bash ~/scripts/buildBodataPost.sh; sleep 40; npm start"
alias cdBo="cd ~/immuta/bodata/service"
alias gFdw="IT_UNOBFUSCATED=true grunt mochaTest:fdw"
alias npmc="cd ~/immuta/bodata/service && npm run console:dev"
alias npms="cd ~/immuta/bodata/service && npm run server"
alias fingerCode="code ~/immuta/fingerprint"
export BODATA_DIR="/Users/jmurray/immuta/bodata"