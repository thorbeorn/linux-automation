function update() {
    apt update -y
}

function upgrade() {
    apt upgrade -y
}

function afficher_choix_Update() {
    clear
    echo "1) Update server"
    echo "2) Upgrade server"
    echo "3) Quit"
    choisir_fonction_Update
}

function choisir_fonction_Update() {
    read -n1 -p "Choose action (1-3) : " Action_Update
    if [ "$Action_Update" == "1" ]; then
        update
    elif [ "$Action_Update" == "2" ]; then
        upgrade
    elif [ "$Action_Update" == "3" ]; then
        clear
        exit
    else
        echo "incorrect entry, please retry !"
        choisir_fonction_Update
    fi
}

afficher_choix_Update