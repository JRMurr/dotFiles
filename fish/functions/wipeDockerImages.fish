function wipeDockerImages
    cleanDocker
    if docker images -q  | count > 0
        docker rmi ( docker images -q)
    end
end