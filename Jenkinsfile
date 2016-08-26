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

    // если использовать oscript -encoding=utf-8, то использовать в Jenkins на Windows ни одно переключение кодировок через chcp ХХХ не даст правильную кодировку, все время будут иероглифы !!
    // в итого в Jenkins на Windows нужно запускать oscript без -encoding=utf-8  

    def commandToRun = "oscript finder.os";
    dir('tests') {
        if (isUnix){
            sh "${commandToRun}"
        } else {
            bat "@chcp 1251 > nul \n${commandToRun}"
        }    
    }

    step([$class: 'JUnitResultArchiver', testResults: '**/tests/*.xml'])

    stage "checkout 1bdd"

    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: '1bdd']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/artbear/1bdd.git']]])

    stage "exec gitsync features"

    command = """oscript ./1bdd/src/bdd.os ./src/gitsync/features -out ./bdd-exec.log"""

    def errors = []
    try{
        if (isUnix){
            sh "${command}"
        } else {
            bat "@chcp 1251 > nul \n${command}"
        }
    } catch (e) {
         errors << "BDD status : ${e}"
    }

    if (errors.size() > 0) {
        currentBuild.result = 'UNSTABLE'
        for (int i = 0; i < errors.size(); i++) {
            echo errors[i]
        }
    }           

    step([$class: 'ArtifactArchiver', artifacts: '**/bdd-exec.log', fingerprint: true])
}