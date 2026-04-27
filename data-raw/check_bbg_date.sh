#!/usr/bin/env bash

curl https://www.bbg.org/collections/cherries >> bbg.html

echo "Today's date: "
TODAY=`date '+%B %-e, %Y'`
TODAY+="."  # Date for BBG has a period at the end
echo $TODAY

echo "BBG's date: "
BBG=`cat bbg.html | grep -oP '(?<=Last update: ).*?(?=<)'`
echo $BBG

if [ "$TODAY" = "$BBG" ]; then
    echo "Pull data!"
else
    echo "Wait to pull data!"
fi

rm bbg.html
