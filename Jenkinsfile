pipeline {
    agent none
    options {
        timeout(time: 2, unit: 'HOURS')
    }
    stages {
        stage("Build and test on all platforms") {
            parallel {
                stage("Win64-Intel") {
                    agent {
                        node {
                            label 'master'
                            customWorkspace "E:/jenkins-pool/${BRANCH_NAME}/${BUILD_NUMBER}"
                        }
                    }
                    options {
                        timeout(time: 2, unit: 'HOURS')
                    }
                    environment {
                        COMPCODE = 'INW'
                        CRBUILDEXIT = 'TRUE'   // exit build script on fail
                        CROPENMP = 'TRUE'
                        CR64BIT = 'TRUE'
                        MKL_DYNAMIC='FALSE'
                        MKL_NUM_THREADS='1'
                        MKL_THREADING_LAYER='SEQUENTIAL'
                        OMP_DYNAMIC='FALSE'
                        OMP_NUM_THREADS='1'
                        BUILD_CAUSE= ''
                        BUILD_CAUSE_MANUALTRIGGER=  ''
                        BUILD_CAUSE_SCMTRIGGER=  ''
                        BUILD_CAUSE_UPSTREAMTRIGGER=  ''
                        ROOT_BUILD_CAUSE=  ''
                        ROOT_BUILD_CAUSE_SCMTRIGGER=  ''
                        ROOT_BUILD_CAUSE_TIMERTRIGGER=  ''
                        BUILD_DISPLAY_NAME=  ''
                        BUILD_ID=  ''
                        BUILD_NUMBER=  ''
                        BUILD_TAG= ''
                        BUILD_URL=  ''
                    }
                    stages {
                        stage('Win64-Intel Build') {                      // Run the build
                            steps {
                                bat '''
                                    call build\\setupenv.ifort_vc.SAYRE.bat
                                    set _MSPDBSRV_ENDPOINT_=%RANDOM%
                                    echo %_MSPDBSRV_ENDPOINT_%
                                    start mspdbsrv -start -spawn -shutdowntime 90000
                                    set
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
                                    for /f "tokens=1* delims==" %%a in ('set') do (
                                      if /i NOT "%%a"=="PATH" set %%a=
                                    )
                                    set CRYSDIR=.\\,..\\build\\
                                    set COMPCODE=INW_OMP
                                    set CROPENMP=TRUE
                                    set CR64BIT=TRUE
                                    set MKL_DYNAMIC=FALSE
                                    set MKL_NUM_THREADS=1
                                    set MKL_THREADING_LAYER=SEQUENTIAL
                                    set OMP_DYNAMIC=FALSE
                                    set OMP_NUM_THREADS=1
                                    set MKL_CBWR=COMPATIBLE
                                    call build\\setupenv.ifort_vc.SAYRE.bat
                                    cd test_suite
                                    mkdir script
                                    echo "%SCRIPT NONE" > script\\tipauto.scp
                                    echo "%END SCRIPT" >> script\\tipauto.scp
                                    del crfilev2.dsc
                                    echo 'Here are the env variables'
                                    set
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



                stage("MinGW") {
                    agent { label 'master' }
                    options {
                        timeout(time: 2, unit: 'HOURS')
                    }
                    environment {
                        COMPCODE = 'MIN'
                        CRBUILDEXIT = 'TRUE'   // exit build script on fail
                        CROPENMP = 'TRUE'
                        CR64BIT = 'TRUE'
                    }
                    stages {
                        stage('MinGW debug build') {                      // Run the build
                            steps {
                                bat '''
                                    call build\\setupenv.SAYRE.bat
                                    rmdir /q/s b
                                    mkdir b
                                    cd b
                                    cmake -DCMAKE_BUILD_TYPE=Debug -DBLA_VENDOR=OpenBLAS -DMINGW=1 -DwxWidgets_ROOT_DIR=%WXWIN% -DwxWidgets_LIB_DIR=%WXLIB% -DwxWidgets_CONFIGURATION=mswu -G"MinGW Makefiles" ..
                                    mingw32-make -j3 || exit 1
                                    echo "Build step complete"
                                '''
                            }
                        }
                        stage('MinGW Smoketest') {
                            environment {
                                CRYSDIR = '.\\,..\\b\\'
                                COMPCODE = 'MIN64'
                            }
                            steps {
                                bat '''
                                    call build\\setupenv.SAYRE.bat
                                    cd test_suite
                                    mkdir script
                                    echo "%SCRIPT NONE" > script\\tipauto.scp
                                    echo "%END SCRIPT" >> script\\tipauto.scp
                                    del crfilev2.dsc
                                    perl testsuite.pl -s
                                '''
                            }
                        }
                        stage('MinGW Build') {                      // Run the build
                            steps {
                                bat '''
                                    call build\\setupenv.SAYRE.bat
                                    rmdir /q/s b
                                    mkdir b
                                    cd b
                                    cmake -DBLA_VENDOR=OpenBLAS -DMINGW=1 -DwxWidgets_ROOT_DIR=%WXWIN% -DwxWidgets_LIB_DIR=%WXLIB% -DwxWidgets_CONFIGURATION=mswu -G"MinGW Makefiles" ..
                                    mingw32-make -j3 || exit 1
                                    echo "Build step complete"
                                '''
                            }
                        }
                        stage('MinGW Test') {
                            environment {
                                CRYSDIR = '.\\,..\\b\\'
                                COMPCODE = 'MIN64'
                            }
                            steps {
                                bat '''
                                    call build\\setupenv.SAYRE.bat
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
                            bat 'ren test_suite MIN64.org'  // Change path here to get unique archive path.
                            archiveArtifacts artifacts: 'MIN64.org/*.out', fingerprint: true
                        }
                    }
                }


                stage("Linux") {
                    agent {label 'orion'}
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


            }
        }

        stage('Win64-Intel Installer') {
/*            when {
              expression {
                   env.BRANCH_NAME == 'master'
              }
            }
*/
            agent {
                node {
                    label 'master'
                    customWorkspace "E:/jenkins-pool/${BRANCH_NAME}/${BUILD_NUMBER}"
                }
            }
            options {
                timeout(time: 2, unit: 'HOURS')
                skipDefaultCheckout()
            }
            environment {
                CRYSDIR = '.\\,..\\build\\'
                COMPCODE = 'INW_OMP'
            }
            steps {
                bat '''
                    call build\\setupenv.ifort_vc.SAYRE.bat
                    cd build
                    call make_w32.bat dist
                    xcopy /s /y ..\\debuginfo c:\\omp17-x64\\
                '''
            }
        }
        stage('Deploy Win64 - master branch only') {
            when {
              expression {
                   env.BRANCH_NAME == 'master'
              }
            }
            agent {
                node {
                    label 'master'
                    customWorkspace "E:/jenkins-pool/${BRANCH_NAME}/${BUILD_NUMBER}"
                }
            }
            options {
                timeout(time: 2, unit: 'HOURS')
                skipDefaultCheckout()
            }
            steps {
                    ftpPublisher alwaysPublishFromMaster: false, masterNodeName: 'master', continueOnError: false, failOnError: false, paramPublish: [parameterName:""], publishers: [
                        [configName: 'CRYSTALSXTL', transfers: [
                            [asciiMode: false, cleanRemote: false, excludes: '', flatten: true, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: "/", remoteDirectorySDF: false, removePrefix: '', sourceFiles: 'installer/**.exe']
                        ], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true]
                    ]
            }

        }

    }
}
