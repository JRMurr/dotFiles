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