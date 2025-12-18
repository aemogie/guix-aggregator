#!/bin/sh
curl -s 'https://codeberg.org/guix/guix.rss' | \
  sed -E '{
    s%<title>%<titlet>%g
    s%<description>%<descriptiont>%g
    s%<descriptiont>([0-9]+)#(.*)#</description>%<title>#\1: \2</title>%g
    s%<titlet>(.*)</title>%<description>\1</description>%g
    s%<descriptiont>(.*)</description>%<title>\1</title>%g
}'
