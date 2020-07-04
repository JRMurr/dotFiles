function cleanDocker
    if docker ps -a -q | count > 0
        docker stop (docker ps -a -q)
        docker rm (docker ps -a -q)
    end
end