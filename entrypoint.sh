#!/bin/bash

### Molecule Plugin
SUB_COMMAND=""
OPTIONS=""
SCENARIO=""

NETRC_FILE="/root/.netrc"

if [ -f "/root/.netrc" ]; then
    echo "${NETRC_FILE} file exists using it!"
else
    echo "${NETRC_FILE} does not exists git commands might fail..."
fi


case "${PLUGIN_TASK}" in
    init)
        case "${PLUGIN_URL}" in
            *)
                PLUGIN_TASK="init"
                SUB_COMMAND="template"
                OPTIONS=('--url' "${PLUGIN_URL}")
                ;;
            "")
                echo "You need to provide a URL to initialize the role from a Cookiecutter template"
                exit 2
                ;;
        esac

        ;;
    login)
        case "${PLUGIN_HOST}" in
            *)
                OPTIONS=('--host' "${PLUGIN_HOST}")
                ;;
            "")
                echo "You need to specify which host you want to connect to"
                exit 3
                ;;
        esac
        ;;

    check|converge|create|dependency|destroy|idempotence|lint|list|prepare|side-effect|syntax|test|verify)
        SCENARIO=('--scenario-name' "${PLUGIN_SCENARIO:-default}")
        ;;
    *)
        # Show molecule usage if no commands are provided
        if [[ -z "${PLUGIN_TASK}" ]]; then
            molecule
            exit 0
        else
            echo "The command ${PLUGIN_TASK} is not supported (yet)."
            exit 1
        fi
        ;;
esac

molecule ${PLUGIN_TASK} ${SCENARIO[@]} ${SUB_COMMAND} ${OPTIONS[@]} ${@}
