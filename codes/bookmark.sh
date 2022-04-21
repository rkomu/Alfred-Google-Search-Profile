#!/bin/sh

current_dir=${PWD}

PROFILE_FILE=$(cat "$current_dir"/profile.txt)
echo "$PROFILE_FILE"

bookmark_file=$(cat /Users/*/Library/Application\ Support/Google/Chrome/"$PROFILE_FILE"/Bookmarks | sed -nE 's+.*("bookmark_bar": {"children": [ { .* }], .*)+\1+p')

echo "$bookmark_file"