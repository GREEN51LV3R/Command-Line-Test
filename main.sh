#!/bin/bash

# Starting Interface

collect=$(./animation.sh $anim)

echo "$collect"

# Function to encrypt username and password
function encrypt() {
    
    # Generate random salt
    SALT="$(openssl rand -base64 48)"
    
    # Encrypt username and password
    encrypt_username="$(echo -n "$1" | openssl enc -aes-256-cbc -a -salt -pass pass:"$SALT")"
    encrypt_password="$(echo -n "$2" | openssl enc -aes-256-cbc -a -salt -pass pass:"$SALT")"
    
    # Store encrypted username and password in a file
    echo "$encrypt_username" >> encrypted_username.txt
    echo "$encrypt_password" >> encrypted_password.txt
    
    echo "$SALT" > salt.txt
}

# Function to check if username and password are correct
function check() {
    
    # Get salt from file
    SALT="$(cat salt.txt)"
    
    # Decrypt username and password
    decrypt_username="$(cat encrypted_username.txt | openssl enc -aes-256-cbc -d -a -salt -pass pass:"$SALT")"
    decrypt_password="$(cat encrypted_password.txt | openssl enc -aes-256-cbc -d -a -salt -pass pass:"$SALT")"
    
    # Check if username and password are correct
    if [ "$decrypt_username" == "$1" ] && [ "$decrypt_password" == "$2" ]; then
        echo "Login successful!"
    else
        echo "Username or password is incorrect!"
    fi
}

# Function to provide signin and signup option
signin_signup() {
    echo "1. Sign in"
    echo "2. Sign up"
    echo "3. Exit"
    read -p "Enter your choice: " choice
    case $choice in
        1)
            read -p "Enter username: " username
            read -p "Enter password: " password
            check "$username" "$password"
            ;;
        2)
            usersecurity
            encrypt "$username" "$password"
            echo "Sign up successful!"
            ;;
        3)
            echo "Thank you ! See You Soon."
            exit
            ;;
        *)
            echo "Invalid choice!"
            ;;
    esac
}

function usersecurity() {
    # user-input
    read -p "Enter username: " i_username
    
    #check the password and username rules
    if [[ $username =~ ^[a-zA-Z0-9]+$ ]]; then
    # user-input password
    read -p "Enter password: " password
    if [[ ${#password} -ge 8 && $password =~ [0-9] && $password =~ [^a-zA-Z0-9] ]]; then
    # re-enter password
    read -p "Please re-enter your new password: " -s password_confirm 
    #check if password match
    if [[ $password == $password_confirm ]]; then
    echo "Password successfully set !"
    else
    echo "Password do not match !"
    fi
    else
    echo "Password must be at least 8 characters long and contain at least a number and symbol ! "
    #calling back
    usersecurity
    fi
    else
    echo "Username must contain only alphanumeric symbols !"
    #calling back 
    usersecurity
    fi
    password_confirm = $password
}

function logs() {
    # check for logfile
    if [ ! -f test_activity.log ]; then 
    #create log-file
    touch test_activity.log
    fi
    #log activity
    echo "$(date +"%Y-%m-%d %T") Activity Logged" >> test_activity.log
}

#start logging-data
logs

# Call signin_signup function
signin_signup
