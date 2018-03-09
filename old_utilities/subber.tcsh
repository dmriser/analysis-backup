#!/bin/tcsh -f

set ifile = 0
set ijsub = 0

set jsub_limit = 1000

# we need to loop on mss files and find out what we already have done 
# to prevent doing them over and over again just to get the last few.

echo " > starting search for missing files, this could take a while..."

set files = `./whatIsMissing 0`

echo " > found $#files missing, sending to farm" 

cp jsubtemplate temp.$ijsub.jsub

foreach file ($files)
    echo $file >> temp.$ijsub.jsub 
	if ($ifile == $jsub_limit) then
	    jsub temp.$ijsub.jsub
	    echo temp.$ijsub.jsub
	    @ ijsub++
	    set ifile = 0
	    cp jsubtemplate temp.$ijsub.jsub	    
	endif
	@ ifile++
end

# send the last and clean
jsub temp.$ijsub.jsub
#rm temp.*.jsub
