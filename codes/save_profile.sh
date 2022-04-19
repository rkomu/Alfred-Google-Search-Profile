current_dir=${PWD}
FILE_PATH="$current_dir"/profile.txt

if [ -f "$FILE_PATH" ]; then
    rm "$FILE_PATH"
fi 

echo {query} > "$FILE_PATH"