#!/bin/bash


#for i in {0..99}
for i in {0..9}
do
	DIRNAME=$(printf "vol%02d" $i)
	oc delete pv $DIRNAME 
	echo "deleted volume $i"
done
