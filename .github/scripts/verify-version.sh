#!/bin/sh
set -eu

expected="$(cat .version)"
actual="$(xclint --version)"

if [ "$actual" != "$expected" ]; then
	echo "xclint --version returned '$actual', expected '$expected'"
	exit 1
fi

echo "xclint --version matches .version ('$actual')"
