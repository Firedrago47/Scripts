#!/bin/bash

echo "Enter the project name:"

read pname

echo "Opening the project..."

cd Documents/Projects/$pname

code .

sleep 2

echo "project opened in vscode"
