#!groovy
node("slave") {
    def isUnix = isUnix();
    stage "checkout"

    if (isUnix && !env.DISPLAY) {
       env.DISPLAY=":1"
    }
    
    checkout scm
    if (isUnix) {sh 'git submodule update --init'} else {bat "git submodule update --init"}
    
    stage "test"

    def commandToRun = "oscript -encoding=utf-8 finder.os";
    dir('tests') {
        if (isUnix){
            sh "${commandToRun}"
        } else {
            bat "${commandToRun}"
        }    
    }

    step([$class: 'JUnitResultArchiver', testResults: '**/tests/*.xml'])
}