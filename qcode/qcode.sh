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

create_p(){
	local pname="$1"
	local path="$PROJECT_DIR/$pname"

	echo -e "${YELLOW}Project $pname does not exist${RESET}"
	read -p "Create it?(y/n):" choice

	if [[ "$choice" != "y" ]]; then
		echo -e "${RED}Cancelled.${RESET}"
		exit 1
	fi

	echo
	echo "Which Project do you wanna Create?(react.js/next.js)"
	echo " ---------------------------------------------------"
	echo "| [1]) react.js					  |"
	echo "| [2]) next.js					  |"
	echo "| [3]) next.js(typescript)			  |"
	echo "| [4]) plank					  |"
	echo " ---------------------------------------------------"
	read -p "select any of (1/2/3/4):" typ
	echo

	case "$typ" in
		1)
			cd "$PROJECT_DIR"
			npx create-react-app "$pname"
			;;
		2)
			cd "$PROJECT_DIR"
			npx create-next-app "$pname"
			;;
		3)
			cd "$PROJECT_DIR"
			npx create-next-app "$pname" --typescript
			;;
		4)
			mkdir -p "$path"
			echo "# $pname" > "$path/README.md"
			;;
		*)
			echo -e "${RED}Unknown Option:${RESET}$typ"
			exit 0
			;;
	esac

	if command -v git >/dev/null; then
        	(cd "$path" && git init >/dev/null)
        	echo -e "${BLUE}Initialized a new Git repo.${RESET}"
   	fi
	
	echo -e "${GREEN}Project created at: $path${RESET}"
}

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
	echo "-s,--select	   Select project folder"
	echo "-c,--create <name>   Create Project"
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
		create_p "$pname"
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
		-c|--create)
			create_p
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
