#!/bin/bash

# Flow and ESLint checker for modified files

if [[ -z `which flow` || -z `which eslint` ]]; then
	echo "No required bin (flow, eslint) was found in the \$PATH"
	exit 1
fi

git status --short
declare -a files=($(git status --short | egrep '\bM\b' | awk '{print $2}'))

for file in "${files[@]}"; do
	echo "===== Flow check for =====: $file"
	flow $file
	echo "===== Eslint check for =====: $file"
	eslint $file
done
