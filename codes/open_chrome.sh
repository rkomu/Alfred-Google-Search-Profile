current_dir=${PWD}
incognito="incognito"
while read -r line; do
if [[ ! "$line" = "$incognito" ]]; then
	open -n -a "Google Chrome" --args --profile-directory="$line" "https://www.google.co.jp/search?q={query}"
else 
	open -n -a "Google Chrome" --args --incognito "https://www.google.co.jp/search?q={query}"
fi
done < "$current_dir"/profile.txt