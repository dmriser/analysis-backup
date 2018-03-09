#!/bin/tcsh 

set listOfFiles = /u/home/dmriser/files.dat
set dirToWatch  = /u/home/dmriser/tempDir/

ls $dirToWatch > $listOfFiles
ls $dirToWatch > currentFiles.dat

while(1)
	sleep 1
	echo "Waking up"

	if(`diff $listOfFiles currentFiles.dat | wc -l` > 0) then
	    echo "Things have changed around here..."
	    rm $listOfFiles
	    rm currentFiles.dat
	    ls $dirToWatch > $listOfFiles
	endif
	
	rm currentFiles.dat 
	ls $dirToWatch > currentFiles.dat 
end
