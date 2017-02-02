#!/bin/bash

# eslint and flow check for modified files

# important! call only from application root directory, e.g:
# $ pwd
# > path/to/my/App
# $ ./sh/fes
# ...launching

if [[ -z `which flow` ]]; then
	echo "No 'flow' binary found. Try: npm i -g flow"
	exit 1
elif [[ -z `which eslint` ]]; then
	echo "No 'eslint' binary found. Try: npm i -g eslint"
	exit 1
fi

gitmodules=`pwd`"/.gitmodules"

if [[ -f "$gitmodules" ]]; then
	declare -a paths=($(grep path "$gitmodules" | awk '{print $3}'))

	concat_path=""
	for path in "${paths[@]}"; do
		concat_path+=$path
	done
fi

git status --short
declare -a files=($(git status --short | grep M | grep -v "$concat_path" | awk '{print $2}')) 

echo "${paths[@]}"
echo "${files[@]}"

for file in "${files[@]}"; do
	for path in "${paths[@]}"; do
		# figure out ..
		if [[ $file =~ $path ]]; then
			continue
		else
			modules_match="true"
			break
		fi
	done

	if [[ -z $modules_match ]]; then
		# echo "========== Flow check for: $file ==========="
		# flow $file
		# echo "========== Eslint check for: $file ==========="
		# eslint $file
		echo "$file is not matches gitmodules paths"
	else
		echo "$file do matches gitmodules paths"
	fi
done
