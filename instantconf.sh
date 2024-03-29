#!/bin/bash

###########################################
## Simple settings manager for instantOS ##
###########################################

sq() {
    sqlite3 ~/.config/instantos/settings.db "$1"
}

echohelp() {
    echo "usage: iconf [arguments]
iconf <settingname>
    get setting value
iconf <setting> <value>
    set setting to value
iconf -r <value>
    get setting from installer
iconf -d <setting>
    clear a setting value
iconf -a
    print all settings
iconf -i
    binary settings using indicator files
    iconf -i <setting>
        get setting value as exit code
    iconf -i <setting> 0/1
        set setting to off/on
iconf -e <output>
    export all settings to output file
iconf -i <file>
    import setting file
iconf --help
    show this message
iconf --version
    TODO
"
    exit
}

case "$1" in
-b) # 1 or 0 to exit code
    shift
    BINARY=True
    ;;
-h)
    echohelp
    exit
    ;;
-d)
    # delete an option
    if [ -n "$2" ]; then
        sq "DELETE FROM settings WHERE setting='$2'"
    fi
    exit
    ;;
-i)
    # use indicator files
    [ -z "$2" ] && exit 1
    if [ -n "$3" ]; then
        if [ "$3" = "0" ]; then
            if [ -e ~/.config/iconf/"$2" ]; then
                rm ~/.config/iconf/"$2"
            fi
        else
            if ! [ -e ~/.config/iconf ]; then
                mkdir -p ~/.config/iconf
            fi
            if ! [ -e ~/.config/iconf/"$2" ]; then
                touch ~/.config/iconf/"$2"
            fi
        fi
        exit 0
    else
        [ -e ~/.config/iconf/"$2" ] && exit 0
    fi
    exit 1
    ;;

-f)
    # store in files instead of sqlite
    shift 1
    if [ -z "$2" ]; then
        if [ -e ~/.config/instantconf/"$1" ]; then
            cat ~/.config/instantconf/"$1"
        else
            exit 1
        fi
    else
        echo "$2" >~/.config/instantconf/"$1"
    fi
    exit
    ;;
-r)
    shift 1
    if [ -z "$1" ]; then
        echo "usage: iroot -r name"
        echo "gets an iroot value from the installer"
        exit
    fi
    # get iroot config
    if [ -e /etc/iroot/"$1" ]; then
        cat /etc/iroot/"$1"
        exit 0
    else
        exit 1
    fi
    ;;
-a)
    sq 'SELECT * FROM SETTINGS'
    exit
    ;;
-e)
    if [ -n "$2" ]; then
        cp ~/.config/instantos/settings.db "$2"
    else
        echo "usage: iconf -e <output>"
    fi
    exit
    ;;

-i)
    if [ -n "$2" ]; then
        cp "$2" ~/.config/instantos/settings.db
        echo 'backed up old settings to  ~/.config/instantos/settings."$(date '+%Y_%m_%d_%H_%M')".db'
        cp ~/.config/instantos/settings."$(date '+%Y_%m_%d_%H_%M')".db
    else
        echo "usage: iconf -i <file>"
    fi
    exit
    ;;
"")
    echohelp
    exit
    ;;
esac

# initialize new settings
if ! [ -e ~/.config/instantos/settings.db ]; then
    mkdir -p ~/.config/instantos
    sq 'CREATE TABLE "settings" ("setting" TEXT constraint_name PRIMARY KEY, "value" TEXT);'
    # default settings
    sq 'INSERT INTO settings (setting, value) VALUES ("welcome", "1")' # startup welcome app
fi

if [ -n "$2" ]; then
    if [[ $2 == *'"'* ]]; then
        sq "REPLACE INTO settings (setting, value) VALUES ('$1', '$(sed 's/"/""/g' <<<"$2")')"
    else
        sq "REPLACE INTO settings (setting, value) VALUES ('$1', '$2')"
    fi
else
    if [ -z "$BINARY" ]; then
        # setting:default returns something even if there's no entry in the database
        if [[ "$1" =~ ":" ]]; then
            SETTING="${1%:*}"
            DEFAULT="${1#*:}"
        else
            SETTING="$1"
        fi

        VALUE=$(sq "SELECT value FROM settings WHERE setting='$SETTING'")
        if [ -z "$VALUE" ]; then
            if [ -z "$DEFAULT" ]; then
                exit 1
            else
                echo "$DEFAULT"
            fi
        else
            echo "$VALUE"
        fi
    else
        VALUE=$(sq "SELECT value FROM settings WHERE setting='$1'")
        if [ "$VALUE" = "1" ]; then
            exit 0
        else
            exit 1
        fi
    fi
fi
