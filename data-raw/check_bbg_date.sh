#!/usr/bin/env bash

curl https://www.bbg.org/collections/cherries >> bbg.html

echo "Today's date: "
date '+%B %-e, %Y'

echo "BBG's date: "
cat bbg.html | grep -oP '(?<=Last update: ).*?(?=<)'

rm bbg.html
