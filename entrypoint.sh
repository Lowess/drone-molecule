#!/bin/bash


drone_netrc(){
    # Populate $HOME/.netrc file, so that Galaxy dependencies can be installed from
    # Bitbucket / Github private repositories
    # https://discourse.drone.io/t/querying-git-repo-after-clone/1998/8
if [[ ! -z "${DRONE_NETRC_MACHINE}" ]]; then
    cat <<-EOF > /root/.netrc
    machine ${DRONE_NETRC_MACHINE}
    login ${DRONE_NETRC_USERNAME}
    password ${DRONE_NETRC_PASSWORD}
EOF

fi
}

local_ssh_agent(){
    # Starts the ssh-agent and add the private key to the authentication agent
    eval $(ssh-agent -s) > /dev/null;
    ssh-add ~/.ssh/id_rsa;
}

### Plugin running on Drone CI/CD (http://drone.io/)
case "${CI}" in
    drone)
        drone_netrc
        ;;
    *) # local environement
        case "${PLUGIN_COMMAND}" in
            test|converge|dependency)
                local_ssh_agent
                ;;
            *)
                # No need to start the ssh agent
                ;;
        esac
        ;;
esac

### Molecule Plugin
SUB_COMMAND=""
OPTIONS=""

case "${PLUGIN_COMMAND}" in
    init)
        case "${PLUGIN_URL}" in
            *)
                PLUGIN_COMMAND="init"
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
        ;;
    *)
        # Show molecule usage if no commands are provided
        if [[ -z "${PLUGIN_COMMAND}" ]]; then
            molecule
            exit 0
        else
            echo "The command ${PLUGIN_COMMAND} is not supported (yet)."
            exit 1
        fi
        ;;
esac

molecule ${PLUGIN_COMMAND} ${SUB_COMMAND} ${OPTIONS[@]}
