if type -q nvm
    nvm use 12
end
sudo ifconfig lo0 alias 10.0.2.2

# ghcup-env
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
test -f /Users/jmurray/.ghcup/env ; and set -gx PATH $HOME/.cabal/bin /Users/jmurray/.ghcup/bin $PATH

#misc
alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias jsonJs="pbpaste | json-to-js --spaces=4 | pbcopy; pbpaste"


set -g BODATA_DIR "/Users/jmurray/immuta/bodata"
set -g FINGERPRINT_DIR "/Users/jmurray/immuta/fingerprint"
set -g CLI_DIR "/Users/jmurray/immuta/cli"
set -g -x NODE_OPTIONS "--max_old_space_size=5120"


set -x GOPATH /Users/jmurray/go/
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin

alias sshB="ssh -A -l jmurray bastion.immuta.com"
alias gUnit="grunt mocha_istanbul:unit"
alias bocode="code ~/immuta/bodata"
alias fingerCode="code ~/immuta/fingerprint"
alias cliCode="code ~/immuta/cli"


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
alias fdwIT="IT_UNOBFUSCATED=true npm run mocha -- fdw_it/fdw.it.spec.js"
alias nodeIT="IT_UNOBFUSCATED=true npm run mocha -- it/*.spec.js"
alias npmc="cd ~/immuta/bodata/service && npm run console:dev"
alias npms="cd ~/immuta/bodata/service && npm run server:dev"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/jmurray/opt/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

function buildPost
    if read_confirm "Do you want to stop and rebuild the pg container?"
        killPg
        pushd $BODATA_DIR
        if not make db VISIBILITY=internal MAKE_JOBS=4
            popd
            return 1
        end
        docker run -d -p 5432:5432 --name=bodata_postgres --add-host=service.immuta:10.0.2.2 -e IMMUTA_REMOTE_QUERY=true -i -t immuta-db
        popd
        docker logs -f bodata_postgres
    end
end

function npmBo
    pushd "$BODATA_DIR/service"
    wipeAllNode
    npm install
    popd
end

function restartPg
    dockerStop bodata_postgres
    docker run -d -p 5432:5432 --name=bodata_postgres --add-host=service.immuta:10.0.2.2 -e IMMUTA_REMOTE_QUERY=true -i -t immuta-db
    docker logs -f bodata_postgres
end

function buildFinger
    docker stop immuta-fingerprint
    docker rm immuta-fingerprint
    pushd $FINGERPRINT_DIR
    make immuta-fingerprint
    docker run \
        --detach \
        --publish 5001:5001 \
        --name=immuta-fingerprint \
        --add-host=db.immuta:10.0.2.2 \
        immuta-fingerprint
    popd
    docker logs -f immuta-fingerprint
end

function fingerBash
    docker exec -it immuta-fingerprint /bin/bash 
end

function buildFingerDev
    docker stop immuta-fingerprint
    docker rm immuta-fingerprint
    docker stop immuta-fingerprint-devel
    docker rm immuta-fingerprint-devel
    pushd $FINGERPRINT_DIR
    make immuta-fingerprint-devel
    echo "run 'poetry run immuta-fingerprint --log-level DEBUG' when u get in the container"
    docker run \
        -it \
        --publish 5001:5001 \
        --name=immuta-fingerprint-devel \
        --add-host=db.immuta:10.0.2.2 \
        -v "$PWD"/fingerprint:/opt/immuta/fingerprint/fingerprint \
        --entrypoint /bin/bash \
        immuta-fingerprint:latest-devel
    popd
end

function buildDevPost
    if read_confirm "Do you want to stop and rebuild the pg container?"
        killPg
        pushd $BODATA_DIR
        if not make db MAKE_JOBS=4
            popd
            return 1
        end
        popd
        pushd $BODATA_DIR/postgresql
        docker build -t immuta-db-dev -f DevDocker .
        # docker run -d -p 5432:5432 -v ${PWD}:/src --name=immuta-db-dev -e IMMUTA_REMOTE_QUERY=true --add-host=service.immuta:10.0.2.2 -it immuta-db-dev 
        # docker run -d --cap-add=SYS_PTRACE --cap-add=SYS_TIME --security-opt seccomp=unconfined -e IMMUTA_REMOTE_QUERY=true -p 5432:5432 -v ${PWD}:/usr/src --name=immuta-db-dev --add-host=service.immuta:10.0.2.2 -it immuta-db-dev
        # docker run -d --cap-add=SYS_PTRACE --cap-add=SYS_TIME --security-opt seccomp=unconfined -e IMMUTA_REMOTE_QUERY=true -p 5432:5432 -p 9091:9091 -v $PWD:/usr/src -v $BODATA_DIR:/bodata --name=immuta-db-dev --add-host=service.immuta:10.0.2.2 -it immuta-db-dev
        docker run -d --cap-add=SYS_PTRACE --cap-add=SYS_TIME --security-opt seccomp=unconfined -e IMMUTA_REMOTE_QUERY=true -p 5432:5432 -v {$PWD}:/usr/src --name=immuta-db-dev --add-host=service.immuta:10.0.2.2 $argv -it immuta-db-dev
        popd
        # docker run -d -p 5432:5432 -v ${PWD}:/src --name=immuta-db-dev -e IMMUTA_REMOTE_QUERY=true --add-host=service.immuta:10.0.2.2 -it immuta-db-dev 
        #docker run -d -p 5432:5432 -v ${PWD}:/src --name=immuta-db-dev --add-host=service.immuta:10.0.2.2 -it immuta-db-dev 
    end
end

function mochaFile
    npx _mocha --inline-diffs -r source-map-support/register -r ts-node/register --timeout 999999 --colors $argv
end


function im --wraps="immuta"
    pushd $CLI_DIR
    go run main.go $argv
    popd
end

function imComplete
    pushd $CLI_DIR
    go run main.go completion fish > ~/.config/fish/completions/immuta.fish
    popd
end