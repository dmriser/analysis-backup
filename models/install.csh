#/bin/tcsh 

# setup environmental variables 
setenv MODELLIB `pwd`
setenv LD_LIBRARY_PATH $MODELLIB/lib/:$LD_LIBRARY_PATH

# compiling libraries 
scons 

# moving to dest
cp *.so $MODELLIB/lib/

cp inclusiveModels/*/*.f $MODELLIB/include/
cp elasticModels/*/*.f $MODELLIB/include/

cp inclusiveModels/*/*.h $MODELLIB/include/
cp elasticModels/*/*.h $MODELLIB/include/

cp inclusiveModels/*/*.hh $MODELLIB/include/

echo "Finished"
