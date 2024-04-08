#!/usr/bin/env bash

#-----------------------------------------------------------------------------------
# 1) If ffmpeg and gifsicle are not installed, script will exit
# 2) `option + right click` will give the option to copy the path name of the .mov file you want to convert
# 3) `cmd + v` to paste that path into script in terminal
# 4) enter in name of gif WITHOUT the gif extension at the end
# 5) script will be saved into downloads
#-----------------------------------------------------------------------------------

if [ -z "$1" ]; then
	echo "Please provide a .mov file to convert"
	exit 1
fi

if ! [ -x "$(command -v ffmpeg)" ]; then
	echo 'Error: ffmpeg is not installed. please install with (brew install ffmpeg)' >&2
	exit 1
fi

if ! [ -x "$(command -v gifsicle)" ]; then
	echo 'Error: gifsicle is not installed. please install with (brew install gifsicle)' >&2
	exit 1
fi

echo -n "enter name for your gif (the script will add the extension for you): "
read -r GIFNAME

ffmpeg -i "$1" -pix_fmt rgb24 -r 10 -vf scale="640:-1" -f gif - | gifsicle --optimize=3 --delay=6 >~/Downloads/"$GIFNAME".gif

echo -e "\nSaved ${GIFNAME}.gif to downloads"
