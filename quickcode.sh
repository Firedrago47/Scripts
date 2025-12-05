#!/bin/bash

echo "Enter the project name:"

read pname

echo "Opening the project..."

cd ~/Documents/Projects/$pname

echo "Which code editor?"

read editor

if [[ $editor == "vscode" ]]; then
	code .
elif [[ $editor == "nvim" ]]; then
	nvim $pname
else
	echo "sorry!only vscode and nvim will work!"
fi

sleep 2

echo "project opened in vscode"
