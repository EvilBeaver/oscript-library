#!groovy
node("slave") {
    def isUnix = isUnix();
    
    stage "checkout"

    checkout scm
    if (isUnix) {sh 'git submodule update --init'} else {bat "git submodule update --init"}

    // stage "checkout oscript-library for testrunner.os"
    // checkout([$class: 'GitSCM', branches: [[name: '*/develop']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'oscript-library']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/EvilBeaver/oscript-library.git']]])

    stage "testing with testrunner.os"

    command = """oscript tests/finder.os"""
    if (isUnix) {sh "${command}"} else {bat "@chcp 1251 > nul \n${command}"}       

    step([$class: 'JUnitResultArchiver', testResults: '**/tests/*.xml'])

    stage "checkout 1bdd"
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: '1bdd']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/artbear/1bdd.git']]])

    stage "exec gitsync features"
    // stage "exec all features"

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