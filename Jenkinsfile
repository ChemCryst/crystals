pipeline {
    agent none
    
    stages {
        stage("Build and test on all platforms") {
            parallel {
                stage("Win64 Intel64") {
                    agent { label 'Dunitz' }
                    stages {
                        stage('Setup') {                     // Setup the environment
                            steps {
                                bat 'call build\\setupenv.DUNITZ'
                            }
                        }
                        stage('Build') {                      // Run the build
                            steps {
                                bat 'cd build'
                                bat 'call make_w32.bat'
                            }
                        }
                        stage('Test') {
                            steps {
                                bat 'cd ..\\test_suite'
                                bat 'mkdir script'
                                bat 'echo "%SCRIPT NONE" > script\\tipauto.scp'
                                bat 'echo "%END SCRIPT" >> script\\tipauto.scp'
                                bat 'del crfilev2.dsc'
                                bat 'set CRYSDIR=.\\,..\\build\\'
                                bat 'perl testsuite.pl'
                            }
                        }
                    }
                }
                stage("Linux") {
                    agent {label 'Orion'}    
                    environment {
                        LD_LIBRARY_PATH = '~/lib64:~/lib:/files/ric/pparois/root/lib64:/files/ric/pparois/root/lib:${env.LD_LIBRARY_PATH}'
                        PATH = "~/bin:/files/ric/pparois/root/bin:$PATH"
                        LD_RUN_PATH = '~/lib64:~/lib:/files/ric/pparois/root/lib64:/files/ric/pparois/root/lib:${env.LD_RUN_PATH}'
                        CPLUS_INCLUDE_PATH = '/files/ric/pparois/root/include/'
                    }
                    stages {
                        stage('Build') {                // Run the build
                            steps {
                                    sh '''
                                        echo $PATH
                                        module load intel/2017
                                        rm -Rf b
                                        mkdir b
                                        cd b
                                        cmake3 -DuseGUI=off -DuseOPENMP=no -DCMAKE_Fortran_COMPILER=gfortran73 -DCMAKE_C_COMPILER=gcc73 -DCMAKE_CXX_COMPILER=g++73 -DBLA_VENDOR=Intel10_64lp  ..
                                        nice -7 make -j6 || exit 1
                                        pwd
                                    '''
                            }
                        }
                        stage('Test') {
                            environment {
                                CRYSDIR = './,../b/'
                                COMPCODE = 'LIN'
                            }
                            steps {
                                    sh '''
                                        pwd
                                        cd ../test_suite
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
        }
    }
}

