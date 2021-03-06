# This shell script will find or generate
#the appropriate basis state file

#input it to the fortran executable solve

#clean up the results


#First, make sure there is a clean workspace

#As fortran's file handling system sucks,
#i use the shell script to generate the files
#that I will be storing. However
#this means that there are keywords that I use
#to output and input my fortran files.

#these keywords, if present in the directory, will
#be overwritten.

#KEYWORDS: out.dat, out_solv.dat, inff1.dat
#ARGS: N, Q, G
FIL1='./out.dat'
FIL2='./out_sol.dat'
FIL3='./inff1.dat'
#Generate Unique Indentifier
TEMP=`date +%s`
if [ -e "$FIL1" ]; then
	echo "REMOVE KEYWORD $FIL1"
	exit

elif [ -e "$FIL2" ]; then
	echo "REMOVE KEYWORD $FIL2"
	exit
elif [ -e "$FIL3" ]; then
	echo "REMOVE KEYWORD $FIL3"
	exit

fi

WORKINGDIR=${TEMP}_WD
mkdir $WORKINGDIR
cd $WORKINGDIR
cp ../basis_gen.sh ./
cp ../bstate.f90 ./
cp ../current_cal.f90 ./
cp ../comp_cal.sh ./

#create and enter unique directory to
#prevent cross contamination
#if the user is running this script
#with more than one value

#Now test or generate basis state

DIR="../BasisStates"
FILTEST="../BasisStates/bstateN$1_Q$2.dat"
if [ -d "$DIR" ]; then
	if [ -e "$FILTEST" ]; then
		cp $FILTEST inff1.dat
		echo "BASIS FOUND"
	else
		./basis_gen.sh $1 $2
		echo "BASIS GENERATED"
		cp inff1.dat $FILTEST
	fi

else
	mkdir $DIR
	./basis_gen.sh
	cp inff1.dat $FILTEST
	cp inff1.dat $FILTEST
	echo "BASIS GENERATED 2"
fi

#Should be a file called inff1.dat in ./ (test)
FILTEST2="./inff1.dat"
if [ ! -e "$FILTEST2" ]; then
	echo "BIG ERROR-check code"
	exit
fi

#compile fortran code
./comp_cal.sh

#delete any log files in directory
if [ -e "./$1_$2_$3_$4.log" ]; then
	rm $1_$2_$3_$4.log
fi

mkdir ../Logs

time ./current $1 $2 $3 $4 > $1_$2_$3_$4.log
mv $1_$2_$3_$4.log ../Logs/$1_$2_$3_$4.log
mv current_matrix_xRE.dat ../Res/current_N$1_Q$2_G$3_Sz$4_xRE.dat
mv current_matrix_xIM.dat ../Res/current_N$1_Q$2_G$3_Sz$4_xIM.dat

mv current_matrix_yRE.dat ../Res/current_N$1_Q$2_G$3_Sz$4_yRE.dat
mv current_matrix_yIM.dat ../Res/current_N$1_Q$2_G$3_Sz$4_yIM.dat

#and the resultsrm bstate
rm solver_cal
rm inff1.dat
cd ../
rm -r $WORKINGDIR
