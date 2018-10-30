pipeline {
    agent none
    
    stages {
        stage("Build and test on all platforms") {
            parallel {
                stage("Win64-Intel") {
                    agent { label 'Dunitz' }
                    environment {
                        COMPCODE = 'INW'
                        CRBUILDEXIT = 'TRUE'   // exit build script on fail
                        CROPENMP = 'TRUE'
                        CR64BIT = 'TRUE'
                    }
                    stages {
                        stage('Win64-Intel Build') {                      // Run the build
                            steps {
                                bat '''
                                    call build\\setupenv.DUNITZ.bat
                                    set _MSPDBSRV_ENDPOINT_=%RANDOM%
                                    echo %_MSPDBSRV_ENDPOINT_%
                                    start mspdbsrv -start -spawn -shutdowntime 90000
                                    cd build
                                    call make_w32.bat
                                    mspdbsrv -stop
                                    echo "Build step complete"
                                '''
                            }
                        }
                        stage('Win64-Intel Test') {
                            environment {
                                CRYSDIR = '.\\,..\\build\\'
                                COMPCODE = 'INW_OMP'
                            }
                            steps {
                                bat '''
                                    call build\\setupenv.DUNITZ.bat
                                    cd test_suite
                                    mkdir script
                                    echo "%SCRIPT NONE" > script\\tipauto.scp
                                    echo "%END SCRIPT" >> script\\tipauto.scp
                                    del crfilev2.dsc
                                    perl testsuite.pl
                                '''
                            }
                        }
                    }
                    post {
                        always {
                            bat 'ren test_suite INW_OMP.org'  // Change path here to get unique archive path.
                            archiveArtifacts artifacts: 'INW_OMP.org/*.out', fingerprint: true
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
                        stage('Linux Build') {                // Run the build
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
                        stage('Linux Test') {
                            environment {
                                CRYSDIR = './,../b/'
                                COMPCODE = 'LIN'
                            }
                            steps {
                                    sh '''
                                        pwd
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
                    post {
                        always {
                            sh 'mv test_suite LIN.org'      // Change path here to get unique archive path.
                            archiveArtifacts artifacts: 'LIN.org/*.out', fingerprint: true
                        }
                    }
                }
                stage("Linux Smoketest") {
                    agent {label 'Orion'}    
                    environment {
                        LD_LIBRARY_PATH = '~/lib64:~/lib:/files/ric/pparois/root/lib64:/files/ric/pparois/root/lib:${env.LD_LIBRARY_PATH}'
                        PATH = "~/bin:/files/ric/pparois/root/bin:$PATH"
                        LD_RUN_PATH = '~/lib64:~/lib:/files/ric/pparois/root/lib64:/files/ric/pparois/root/lib:${env.LD_RUN_PATH}'
                        CPLUS_INCLUDE_PATH = '/files/ric/pparois/root/include/'
                    }
                    stages {
                        stage('Build Linux Smoketest') {                // Run the build
                            steps {
                                    sh '''
                                        echo $PATH
                                        module load intel/2017
                                        rm -Rf b
                                        mkdir b
                                        cd b
                                        cmake3 -DCMAKE_BUILD_TYPE=Debug -DuseGUI=off -DCMAKE_Fortran_COMPILER=gfortran73 -DCMAKE_C_COMPILER=gcc73 -DCMAKE_CXX_COMPILER=g++73 -DuseOPENMP=off -DBLA_VENDOR=OpenBLAS -DBLAS_LIBRARIES=/files/ric/pparois/root/lib/libopenblas.so -DLAPACK_LIBRARIES=/files/ric/pparois/root/lib/libopenblas.so ..
                                        nice -7 make -j6 || exit 1
                                        pwd
                                    '''
                            }
                        }
                        stage('Run Linux Smoketest') {
                            environment {
                                CRYSDIR = './,../b/'
                                COMPCODE = 'LIN'
                            }
                            steps {
                                    sh '''
                                        pwd
                                        cd test_suite
                                        mkdir -p script
                                        echo "%SCRIPT NONE" > script/tipauto.scp
                                        echo "%END SCRIPT" >> script/tipauto.scp
                                        rm -f crfilev2.dsc
                                        rm -f crfilev2.h5
                                        rm -f gui.tst
                                        nice -10 perl testsuite.pl -s
                                    '''
                                
                            }
                        }
                    }
                }
            }
        }
    }
}




