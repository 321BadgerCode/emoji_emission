#!/bin/bash
echo "Enter the emoji name to look for possible unicode hex values."
echo "Enter the hex value followed by '*' to look for possible unicode hex values."
echo "Type \"exit\" to exit the program."

emojis=()
for i in {1..2}; do
	while [ true ]; do
		echo ""
		echo -n "Unicode hex value: "
		read emoji
		if [[ $emoji == "exit" ]]; then
			exit 0
		elif [[ ! $emoji =~ ^[0-9A-Fa-f]+$ ]]; then
			grep -i $emoji ./emoji_labels.txt | sed 's/,//g'
		elif [[ $emoji =~ ^[0-9A-Fa-f]{1,3}\*$ ]]; then
			# grep to look for unicode hex that start with emoji
			# "emoji_" . label . "_" . unicode_hex_value . ",\t*" . emoji_character
			grep -i "^emoji_.*_${emoji%?}" ./emoji_labels.txt
		elif [[ $emoji =~ ^[0-9A-Fa-f]{4,5}$ ]]; then
			emojis+=($emoji)
			break
		else
			echo "Invalid input"
		fi
	done
	echo "Emoji # $i is set: ${emojis[i-1]}"
done

if [[ -f ./emoji_mix/${emojis[0]}/${emojis[0]}_${emojis[1]}.png ]]; then
	open ./emoji_mix/${emojis[0]}/${emojis[0]}_${emojis[1]}.png
elif [[ -f ./emoji_mix/${emojis[1]}/${emojis[1]}_${emojis[0]}.png ]]; then
	open ./emoji_mix/${emojis[1]}/${emojis[1]}_${emojis[0]}.png
else
	echo "The provided emojis are not compatible."
fi
