current_dir=${PWD}
JSON_PATH="$current_dir"/account.json

JSON_DATA=$(<"$JSON_PATH")
echo ${JSON_DATA}