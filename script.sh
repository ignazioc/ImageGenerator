#! /bin/bash

#COLOR="rgb(135, 185, 25)" #green
#COLOR="rgb(229, 50, 56)" #red
COLOR="rgb(0, 98, 212)" #blue
# COLOR="rgb(245, 175, 2)" #yellow





convert \
  -background "$COLOR" \
  -font "Paralucent Condensed Heavy.otf" \
  -fill white \
  -pointsize 210 \
  label:'This is the combination' \
  -gravity south \
  -splice 0x10 \
  combination.png


convert \
  -background "$COLOR" \
  -font "Paralucent Condensed Heavy.otf" \
  -fill white \
  -pointsize 210 \
  label:'of a headline with and' \
  -bordercolor "$COLOR" \
  -border  0x10 \
  headline.png

convert \
  -background "$COLOR" \
  -font "Paralucent Condensed Heavy.otf" \
  -fill white \
  -pointsize 210 \
  -splice 0x15 \
  label:'following Dojos rules.' \
  dojo.png



convert \
  -background "$COLOR" \
  -font "Paralucent Condensed Heavy.otf" \
  -fill white \
  -pointsize 210 \
  label:'without' \
  -gravity east \
  -splice 40x0 \
  without.png

convert \
  -background white \
  -font "Paralucent Condensed Heavy.otf" \
  -fill "$COLOR" \
  -pointsize 210 \
  -bordercolor white \
  -border 40x8 \
  -kerning 1.5 \
  label:'highlighted' \
  hightlighted.png

convert \
  -background "$COLOR" \
  -font "Paralucent Condensed Heavy.otf" \
  -fill white \
  -pointsize 210 \
  -splice 40x0 \
  label:' text,' \
  text.png

convert \
  without.png \
  hightlighted.png \
  text.png \
  -gravity center \
  +append \
  result.png

convert \
    combination.png \
    headline.png \
    result.png \
    dojo.png \
    -bordercolor "$COLOR" \
    -append \
    -border 160 \
    full_blue.png && open -a Pixelmator full_blue.png
