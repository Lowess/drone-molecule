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
    chmod 600 /root/.netrc
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
        case "${PLUGIN_TASK}" in
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

molecule ${PLUGIN_TASK} ${SUB_COMMAND} ${OPTIONS[@]}
