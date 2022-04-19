#!/bin/sh

current_dir=${PWD}
# echo ${current_dir}
cd /Users/*/Library/Application\ Support/Google/Chrome
# grep -o --include='Preferences' '"last_list_accounts_data":"\[\\"gaia.l.a.r\\",\[\[\\"gaia.l.a\\",1,\\".*\\",\\".*\\",\\"https:' -r ./
grep -o --include='Preferences' '"last_list_accounts_data":"\[\\"gaia.l.a.r\\",\[\[\\"gaia.l.a\\",1,\\".*\\",\\".*\\",\\"https:' -r ./ > "$current_dir"/accounts.txt
# cat ${current_dir}/accounts.txt


CSV_PATH="$current_dir"/account.csv
JSON_PATH="$current_dir"/account.json

if [ -f "$CSV_PATH" ]; then
    rm "$CSV_PATH"
fi 

if [ -f "$JSON_PATH" ]; then
    rm "$JSON_PATH"
fi 

echo "file, name, email" > "$CSV_PATH"
echo "{\"items\": [" > "$JSON_PATH"

txt_last_line=$(wc -l < "$current_dir"/accounts.txt)
current_line=0

echo "{\"uid\": \"incognito\",\"type\": \"file\",\"title\": \"incognito\",\"subtitle\": \"$incognito\",\"arg\": \"incognito\",\"autocomplete\": \"\",\"icon\": {\"type\": \"fileicon\",\"path\": \"~/Desktop\"}}," >> "$JSON_PATH"

while read -r line; do
# reading each line

    profile_file=$(echo ${line} | sed -nE 's+\.\/\/(.*)\/Preferences:.*+\1+p')
    profile_name=$(echo ${line}  | sed -nE 's+.*1,\\"(.*)\\",\\".*\\",\\"https:+\1+p')
    profile_email=$(echo ${line}  | sed -nE 's+.*1,\\".*\\",\\"(.*)\\",\\"https:+\1+p')

    # profile_file=$(echo ${profile_file} | sed 's/ /\\\\ /g')

    current_line=$(($current_line + 1))

    #echo "PROFILE_FILE:${profile_file}  PROFILE_NAME:${profile_name}  PROFILE_EMAIL:${profile_email}"
    echo "${profile_file},${profile_name},${profile_email}" >> "$CSV_PATH"
    
    # if it was the last line
    if [[ "$current_line" -ne "$txt_last_line" ]]; then
        echo "{\"uid\": \"${profile_file}\",\"type\": \"file\",\"title\": \"${profile_name}\",\"subtitle\": \"${profile_email}\",\"arg\": \"${profile_file}\",\"autocomplete\": \"\",\"icon\": {\"type\": \"fileicon\",\"path\": \"~/Desktop\"}}," >> "$JSON_PATH"
        # echo ${line}
        # echo "NOT_LAST_LINE"
    else
        echo "{\"uid\": \"${profile_file}\",\"type\": \"file\",\"title\": \"${profile_name}\",\"subtitle\": \"${profile_email}\",\"arg\": \"${profile_file}\",\"autocomplete\": \"\",\"icon\": {\"type\": \"fileicon\",\"path\": \"~/Desktop\"}}" >> "$JSON_PATH"
        # echo ${line}
        # echo "LAST_LINE"
    fi 

done < "$current_dir"/accounts.txt

echo "]}" >> "$JSON_PATH"

JSON_DATA=$(<"$JSON_PATH")

echo ${JSON_DATA}
