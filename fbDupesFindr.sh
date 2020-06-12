#!/bin/bash
# FacebookDuplicatesFinder
# Author: @paucabral
# Note: This is a derivative of @linux_choice's userrecon

trap 'printf "\n";partial;exit 1' 2

banner() {
echo ""               
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m]Facebook Duplicates Finder\e[0m\n"
echo "# Author: @paucabral"
echo "# Note: This is a derivative of @linux_choice's userrecon."
echo ""
echo "Instructions: Enter username under the format <firstname>.<lastname>. This script will list up to 10000 duplicate accounts based from this format. A common format of duplicates under the pattern www.facebook.com/firstname.lastname.<digits>".
echo ""
echo ""
}

if [ ! -d results ]; then
mkdir results
fi

partial() {
if [[ -e results/$username.txt ]]; then
echo "Links Found:"
cat results/$username.txt
echo ""
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Saved:\e[0m\e[1;77m %s.txt\n" $username
fi
}

scanner() {
read -p $'\e[1;92m[\e[0m\e[1;77m?\e[0m\e[1;92m] Input Username:\e[0m ' username

if [[ -e results/$username.txt ]]; then
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Removing previous file:\e[0m\e[1;77m %s.txt" $username
rm -rf results/$username.txt
fi
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Checking username\e[0m\e[1;77m %s\e[0m\e[1;92m on: \e[0m\n" $username


## Facebook

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Facebook: \e[0m"
check_face=$(curl -s "https://www.facebook.com/$username" -L -H "Accept-Language: en" | grep -o 'not found'; echo $?)


if [[ $check_face == *'1'* ]]; then
printf "\e[1;92m Found!\e[0m https://www.facebook.com/%s\n" $username
printf "https://www.facebook.com/%s\n" $username >> results/$username.txt
elif [[ $check_face == *'0'* ]]; then
printf "\e[1;93mNot Found!\e[0m\n"
fi

## Dupes
for i in {0..9999}

do
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Facebook $i: \e[0m"
check_face=$(curl -s "https://www.facebook.com/$username.$i" -L -H "Accept-Language: en" | grep -o 'not found'; echo $?)


if [[ $check_face == *'1'* ]]; then
printf "\e[1;92m Found!\e[0m https://www.facebook.com/%s\n" $username.$i
printf "https://www.facebook.com/%s\n" $username.$i >> results/$username.txt
elif [[ $check_face == *'0'* ]]; then
printf "\e[1;93mNot Found!\e[0m\n"
fi

done


partial
}
banner
scanner
