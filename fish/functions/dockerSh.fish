function dockerSh --wraps="docker exec" 
    docker exec -it $argv /bin/sh
end