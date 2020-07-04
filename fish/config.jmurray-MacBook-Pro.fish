if type -q nvm
    nvm use 10
end
sudo ifconfig lo0 alias 10.0.2.2

#misc
alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias jsonJs="pbpaste | json-to-js --spaces=4 | pbcopy; pbpaste"


set -g BODATA_DIR "/Users/jmurray/immuta/bodata"
set -g FINGERPRINT_DIR "/Users/jmurray/immuta/fingerprint"


alias sshB="ssh -A -l jmurray bastion.immuta.com"
alias gUnit="grunt mocha_istanbul:unit"
alias bocode="code ~/immuta/bodata"
alias fingerCode="code ~/immuta/fingerprint"

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



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/jmurray/opt/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

function killPg
    docker stop bodata_postgres
    docker rm bodata_postgres
    docker stop immuta-db-dev
    docker rm immuta-db-dev
end

function buildPost
    killPg
    pushd $BODATA_DIR
    make db MAKE_JOBS=4
    docker run -d -p 5432:5432 --name=bodata_postgres --add-host=service.immuta:10.0.2.2 -e IMMUTA_REMOTE_QUERY=true -i -t immuta-db:latest-odbc
    popd
    docker logs -f bodata_postgres
end

function buildFinger
    docker stop immuta-fingerprint
    docker rm immuta-fingerprint
    pushd $FINGERPRINT_DIR
    make fingerprint
    docker run -d -p 5001:5001 --name=immuta-fingerprint --add-host=db.immuta:10.0.2.2 immuta-fingerprint
    popd
    docker logs -f immuta-fingerprint
end

function buildDevPost
    killPg
    pushd $BODATA_DIR
    make db MAKE_JOBS=4
    popd
    pushd $BODATA_DIR/postgresql
    docker build -t immuta-db-dev -f DevDocker .
    # docker run -d -p 5432:5432 -v ${PWD}:/src --name=immuta-db-dev -e IMMUTA_REMOTE_QUERY=true --add-host=service.immuta:10.0.2.2 -it immuta-db-dev 
    # docker run -d --cap-add=SYS_PTRACE --cap-add=SYS_TIME --security-opt seccomp=unconfined -e IMMUTA_REMOTE_QUERY=true -p 5432:5432 -v ${PWD}:/usr/src --name=immuta-db-dev --add-host=service.immuta:10.0.2.2 -it immuta-db-dev
    docker run -d --cap-add=SYS_PTRACE --cap-add=SYS_TIME --security-opt seccomp=unconfined -e IMMUTA_REMOTE_QUERY=true -p 5432:5432 -p 9091:9091 -v $PWD:/usr/src -v $BODATA_DIR:/bodata --name=immuta-db-dev --add-host=service.immuta:10.0.2.2 -it immuta-db-dev
    popd
    # docker run -d -p 5432:5432 -v ${PWD}:/src --name=immuta-db-dev -e IMMUTA_REMOTE_QUERY=true --add-host=service.immuta:10.0.2.2 -it immuta-db-dev 
    #docker run -d -p 5432:5432 -v ${PWD}:/src --name=immuta-db-dev --add-host=service.immuta:10.0.2.2 -it immuta-db-dev 
end

