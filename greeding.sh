#!/bin/bash

user=$(whoami)
date=$(date)

echo "whats your name?"

read name

echo "whats your age?"

read age

rich=$(($(($RANDOM % 14))+ $age))

echo "Good Morning $name"

sleep 3

echo "You're looking great today $date"

sleep 3

echo "Welcome to the terminal"
echo "$PWD, $SHELL, $USER, $HOSTNAME"

sleep 2

echo "$name, you will get rich at the age of $rich"
