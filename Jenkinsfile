pipeline {
    agent {label 'Orion'}    
    stages {
        stage('Build') {
      // Run the build
            steps {
                withEnv(['LD_LIBRARY_PATH=~/lib64:~/lib:/files/ric/pparois/root/lib64:/files/ric/pparois/root/lib:$LD_LIBRARY_PATH', 'PATH+EXTRA=~/bin:/files/ric/pparois/root/bin', 'LD_RUN_PATH=~/lib64:~/lib:/files/ric/pparois/root/lib64:/files/ric/pparois/root/lib:$LD_RUN_PATH', 'CPLUS_INCLUDE_PATH=/files/ric/pparois/root/include/']) {
                    sh '''module load intel/2017
rm -Rf b
mkdir b
cd b
cmake3 -DuseGUI=off -DuseOPENMP=no -DCMAKE_Fortran_COMPILER=gfortran73 -DCMAKE_C_COMPILER=gcc73 -DCMAKE_CXX_COMPILER=g++73 -DBLA_VENDOR=Intel10_64lp  ..
nice -7 make -j6 || exit 1'''
                }
            }
        }
        stage('Test') {
            steps {
                withEnv(['LD_LIBRARY_PATH=~/lib64:~/lib:/files/ric/pparois/root/lib64:/files/ric/pparois/root/lib:$LD_LIBRARY_PATH', 'PATH+EXTRA=~/bin:/files/ric/pparois/root/bin', 'LD_RUN_PATH=~/lib64:~/lib:/files/ric/pparois/root/lib64:/files/ric/pparois/root/lib:$LD_RUN_PATH', 
                'CPLUS_INCLUDE_PATH=/files/ric/pparois/root/include/',
                'CRYSDIR=./,../b/','COMPCODE=LIN']) {
                    sh '''module load intel/2017
cd test_suite
mkdir -p script
echo "%SCRIPT NONE" > script/tipauto.scp
echo "%END SCRIPT" >> script/tipauto.scp
rm -f crfilev2.dsc
rm -f crfilev2.h5
rm -f gui.tst
nice -10 perl testsuite.pl
'''
                }
            }
        }
    }
}
