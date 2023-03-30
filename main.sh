#!/bin/bash

# Starting Interface

collect=$(./animation.sh $anim)

echo "$collect"

# Provide a prompt for the user to sign-up and sign-in 

echo "Would you like to Sign-in (1) or Sign-up (2) or Exit (3) ? "
read user_input
if [ -z "$user_input" ]; then
echo " We don't accept the blank space, try again "
fi

#check user_input
if [ "$user_input" == "1" ]; then
    read -p "Enter Username : " r_username
    echo "Enter password"
    read r_password
    read -p "Enter Email: " r_email
    echo "$r_username:$r_password" >> user_cred.txt # storing user information 
    echo "$r_email" >> user_email.txt # store user email
elif [ "$user_input" == "2" ]; then
    read -p "Enter your username" username
    echo "Note :User's password section is hidden while entering input"
    echo "Enter your password"
    read -s password
        if grep -q "$username:$password" user_cred.txt; then
            echo "Login sucessful!"
        else 
            echo "Username or Password Incorrect. Please try angain."
        fi
elif [ "$user_input" == "3" ]; then
    echo "Thank you for your visit. See you soon"
    exit 
else
    echo "Invalid input, Please provide clear instructions"
fi

