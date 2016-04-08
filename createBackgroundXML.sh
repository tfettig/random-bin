#!/bin/bash
# A script for generating Ubuntu based wallpaper rotations xml files.
#
# I didn't write this original. I'm pretty sure this person wrote part/most of it
# http://ubuntuforums.org/archive/index.php/t-1860643.html. They probably picked it up parts of it from from
# http://ubuntuforums.org/showthread.php?t=1478700.
#
# What I do know was that this portion of the code solved the problem I was having when I needed it, and it's the best
# type of simple... Stupid simple.

# If there are less then 4 parameters then display the help.
if [ $# -lt 4 ]; then
    echo "usage: $0 <hold duration> <fade duration> file1 file2 ..."
    echo "example: $0 60 5 /path/to/dir/*.jpg /path/to/dir/*.png > background.xml"
    exit 1
fi

# Setup some local vars to remember parameters before they get shifted away into sweet oblivion.
hold=$1
fade=$2
first=$3

# Remove the first and second parameter ($1 and $2).
shift
shift

echo "<background>"
echo "  <starttime>"
echo "    <year>2009</year>"
echo "    <month>08</month>"
echo "    <day>04</day>"
echo "    <hour>00</hour>"
echo "    <minute>00</minute>"
echo "    <second>00</second>"
echo "  </starttime>"
echo "  <!-- This animation will start at midnight. -->"

# While the number of parameters left is greater then 0 then keep looping.
while [ $# -gt 0 ]; do
    echo "  <static>"
    echo "    <duration>$hold</duration>"
    echo "    <file>$1</file>"
    echo "  </static>"
    echo "  <transition>"
    echo "    <duration>$fade</duration>"
    echo "    <from>$1</from>"

    # If the script is NOT down the last one then set the <to> the transition to the next image on the list.
    # Otherwise set the <to> transition back to the first image.
    if [ $# -gt 1 ]; then
        echo "    <to>$2</to>"
    else
        echo "    <to>$first</to>"
    fi
    echo "  </transition>"

    # Remove the current parameter
    shift
done
echo "</background>"
