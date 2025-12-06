#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

CONF_FILE="$HOME/.qcode.conf"

if [[ -f "$CONF_FILE" ]]; then 
	source "$CONF_FILE"
else
	echo "Config file path missing or incorrect check that!!"
fi

select_f(){
	command -v fzf >/dev/null 2>&1 || {
		echo -e "${RED}fzf is not installed!${RESET}"
        	echo "Install it using: sudo apt install fzf  OR  sudo pacman -S fzf"
        	exit 1
	}
	
	echo -e "${YELLOW}Select a project:${RESET}"
	
	if [[ ! -d "$PROJECT_DIR" ]]; then
		echo -e "${RED}Project directory not found: $PROJECT_DIR${RESET}"
        	exit 1
	fi

	choice=$(find "$PROJECT_DIR" -maxdepth 1 -mindepth 1 -type d -printf "%f\n" | fzf)

	[[ -z "$choice" ]] && {
		echo -e "${RED}Project not selected.${RESET}"
		exit 1
	}

	PROJECT="$choice"
	echo -e "${GREEN}Project Selected.${RESET}"
}

show_help(){
	echo -e "${BLUE}qcode - Opens/Create Projects Instantly ${RESET}"
	echo 
	echo "Usage: qcode [options]"
	echo
	echo "Options:"
	echo "-p,--project <name>  Project name"
	echo "-e,--editor <editor> Code Editors"
	echo "-l,--list            list files/folders"
	echo "-h,--help		   show this help"
	echo
	exit 0
}

list_project() {
    echo -e "${YELLOW}Available Projects:${RESET}"

    if [[ ! -d "$PROJECT_DIR" ]]; then
        echo -e "${RED}Project directory not found: $PROJECT_DIR ${RESET}"
        exit 1
    fi

    ls -1 "$PROJECT_DIR"
    exit 0
}


show_error(){
	echo -e "${RED} [ERROR] ${RESET} $1"
	exit 1
}

open_project(){
	local pname="$1"
	local editor="$2"
	local path="$PROJECT_DIR/$pname"
	
	if [[ ! -d "$path" ]]; then 
		show_error "Project $pname does not exist in $PROJECT_DIR"
	fi

	cd "$path" || show_error "couldn't enter the project directory"

	case "$editor" in 
		vscode)
			command -v code >/dev/null || show_error "VS Code (code) not installed"
			code .
			;;
		nvim)
			command -v nvim >/dev/null || show_error "NeoVim not installed"
			nvim .
			;;
		*)
			show_error "Unknown Editor:Here only support Vscode|nvim"
			;;
	esac
	echo -e "${GREEN}Project $pname opened Successfully in $editor ${RESET}"

}

PROJECT=""
EDITOR=""

while [[ "$#" -gt 0 ]] do
	case "$1" in 
		-p|--project)
			PROJECT="$2"
			shift 2
			;;
		-e|--editor)
			EDITOR="$2"
			shift 2
			;;
		-s|--select)
			select_f
			shift
			;;
		-l|--list)
			list_project
			;;
		-h|--help)
			show_help
			;;
		*)
			show_error "Unknown Option "$1""
			;;
	esac
done

[[ -z "$PROJECT" ]] && show_error "No Project Specified.Use -p <name>"
[[ -z "$EDITOR" ]] && EDITOR="$DEFAULT_EDITOR"

open_project "$PROJECT" "$EDITOR"
