pipeline {
    agent none
    options {
        timeout(time: 1, unit: 'HOURS') 
    }
    stages {
        stage("Build and test on all platforms") {
            parallel {
                stage("Win64-Intel") {
                    agent { label 'Dunitz' }
                    options {
                        timeout(time: 1, unit: 'HOURS') 
                    }
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
                        stage('Win64-Intel Installer') {
                            environment {
                                CRYSDIR = '.\\,..\\build\\'
                                COMPCODE = 'INW_OMP'
                            }
                            steps {
                                bat '''
                                    call build\\setupenv.DUNITZ.bat
                                    cd build
                                    call make_w32.bat dist
                                    xcopy /s /y ..\\debuginfo e:\\omp17-x64\\
                                '''
                            }
                        }
                        stage('Deploy') {
                            when {
                              expression {
                                ( currentBuild.result == null || currentBuild.result == 'SUCCESS' ) && env.BRANCH_NAME == 'master'
                              }
                            }
                            steps {
                                ftpPublisher alwaysPublishFromMaster: false, masterNodeName: 'master', continueOnError: false, failOnError: false, paramPublish: [parameterName:""], publishers: [
                                    [configName: 'crystals.xtl', transfers: [
                                        [asciiMode: false, cleanRemote: false, excludes: '', flatten: true, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: "/", remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'installer/**.exe']
                                    ], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true]
                                ]
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
                
                stage("Win32-Intel") {
                    agent { label 'Dunitz' }
                    options {
                        timeout(time: 1, unit: 'HOURS') 
                    }
                    environment {
                        COMPCODE = 'INW'
                        CRBUILDEXIT = 'TRUE'   // exit build script on fail
                        CROPENMP = 'TRUE'
                        CR64BIT = 'FALSE'
                    }
                    stages {
                        stage('Win32-Intel Build') {                      // Run the build
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
                        stage('Win32-Intel Test') {
                            environment {
                                CRYSDIR = '.\\,..\\build\\'
                                COMPCODE = 'INW32'
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
                        stage('Win32-Intel Installer') {
                            environment {
                                CRYSDIR = '.\\,..\\build\\'
                                COMPCODE = 'INW'
                            }
                            steps {
                                bat '''
                                    call build\\setupenv.DUNITZ.bat
                                    cd build
                                    call make_w32.bat dist
                                '''
                            }
                        }
                    }
                    post {
                        always {
                            bat 'ren test_suite INW32.org'  // Change path here to get unique archive path.
                            archiveArtifacts artifacts: 'INW32.org/*.out', fingerprint: true
                        }
                        success  {
                            ftpPublisher alwaysPublishFromMaster: false, masterNodeName: 'master', continueOnError: false, failOnError: false, paramPublish: [parameterName:""], publishers: [
                                [configName: 'crystals.xtl', transfers: [
                                    [asciiMode: false, cleanRemote: false, excludes: '', flatten: true, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: "/", remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'installer/**.exe']
                                ], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true]
                            ]
                        }
                    }
                }
                
                
                
                
                stage("Linux") {
                    agent {label 'Orion'}    
                    options {
                        timeout(time: 1, unit: 'HOURS') 
                    }
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
                                                rm -Rf d
                                                mkdir d
                                                cd d
                                                cmake3 -DCMAKE_BUILD_TYPE=Debug -DuseGUI=off -DCMAKE_Fortran_COMPILER=gfortran73 -DCMAKE_C_COMPILER=gcc73 -DCMAKE_CXX_COMPILER=g++73 -DuseOPENMP=off -DBLA_VENDOR=OpenBLAS -DBLAS_LIBRARIES=/files/ric/pparois/root/lib/libopenblas.so -DLAPACK_LIBRARIES=/files/ric/pparois/root/lib/libopenblas.so ..
                                                nice -7 make -j6 || exit 1
                                                pwd
                                            '''
                            }
                        }
                        stage('Run Linux Smoketest') {
                            environment {
                                CRYSDIR = './,../d/'
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
                stage("OSX") {
                    agent {label 'Flack'}    
                    options {
                        timeout(time: 1, unit: 'HOURS') 
                    }
                    environment {
                        PATH = "/Applications/CMake.app/Contents/bin:$PATH"
                    }
                    stages {
                        stage('OSX Build') {                // Run the build
                            steps {
                                    sh '''
                                        rm -Rf b
                                        mkdir b
                                        cd b
                                        cmake -DCMAKE_NOCOLOR=yes -DMINGW=1 -DuseGUI=off -G"Unix Makefiles" ..
                                        make -j6 || exit 1
                                    '''
                            }
                        }
                        stage('OSX Test') {
                            environment {
                                CRYSDIR = './,../b/'
                                COMPCODE = 'OSXCLI'
                            }
                            steps {
                                    sh '''
                                        cd test_suite
                                        mkdir -p script
                                        rm -f crfilev2.dsc
                                        rm -f gui.tst
                                        perl testsuite.pl
                                    '''
                            }
                        }
                    }
                    post {
                            always {
                                sh 'mv test_suite OSXCLI.org'      // Change path here to get unique archive path.
                                archiveArtifacts artifacts: 'OSXCLI.org/*.out', fingerprint: true
                            }
                    }
                }
            }
        }
       
    }
}






