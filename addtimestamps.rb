#! /bin/ruby 
#for i in `find /raspitimelapse/ -name \*.jpg`; do
#	STAMP=`/bin/date -r $i +"%H:%M:%S %d-%m-%Y"`
#	/usr/bin/convert -pointsize 40 -size 1280x700 xc:none -fill red -gravity SouthEast -draw "text 30,10 '$STAMP'" miff:- | /usr/bin/composite -tile - $i $i
#done

