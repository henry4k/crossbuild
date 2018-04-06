docker_env()
{
    docker image inspect \
        --format '{{range $_, $e := .Config.Env}}{{println $e}}{{end}}' \
        "$(cat .image_id)"
}

triples()
{
    docker_env | \
        sed --quiet --regexp-extended 's/^.+?_TRIPLES=(.+)$/\1/p' | \
        tr ',' ' ' | \
        tr --delete "\n"
}

run_docker()
{
    docker run --rm \
               -v "$(pwd)/test:/test" \
               "$(cat .image_id)" \
               $@
}


# TAP functions:

_executed_tests=0

plan()
{
    local count=${1:?}
    echo "1..$count"
}

diag_stream()
{
    sed 's/^/# /'
}

diag()
{
    echo "$@" | diag-stream
}

ok()
{
    local result=${1:?}
    local name=$2

    _executed_tests=$(($_executed_tests + 1))

    if [[ $result -ne 0 ]]; then
        echo -n 'not '
    fi
    echo -n "ok $_executed_tests"

    if [[ -n "$name" ]]; then
        echo -n " - $name"
    fi

    echo # print \n
}

skip()
{
    local reason=$1
    _executed_tests=$(($_executed_tests + 1))
    echo "ok $_executed_tests # skip $reason"
}
