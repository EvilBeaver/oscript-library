#!groovy
node("slave") {
    // ВНИМАНИЕ:
    // Jenkins и его ноды нужно запускать с кодировкой UTF-8
    //      строка конфигурации для запуска Jenkins
    //      <arguments>-Xrs -Xmx256m -Dhudson.lifecycle=hudson.lifecycle.WindowsServiceLifecycle -Dmail.smtp.starttls.enable=true -Dfile.encoding=UTF-8 -jar "%BASE%\jenkins.war" --httpPort=8080 --webroot="%BASE%\war" </arguments>
    //
    //      строка для запуска нод
    //      @"C:\Program Files (x86)\Jenkins\jre\bin\java.exe" -Dfile.encoding=UTF-8 -jar slave.jar -jnlpUrl http://localhost:8080/computer/slave/slave-agent.jnlp -secret XXX
    //      подставляйте свой путь к java, порту Jenkins и секретному ключу
    //
    // Если запускать Jenkins не в режиме UTF-8, тогда нужно поменять метод cmd в конце кода, применив комментарий к методу

    def isUnix = isUnix();

    stage "checkout"

    if (isUnix && !env.DISPLAY) {
       env.DISPLAY=":1"
    }
    
    checkout scm
    cmd('git submodule update --init')
    
    stage "test"

    // если использовать oscript -encoding=utf-8, то использовать в Jenkins на Windows ни одно переключение кодировок через chcp ХХХ не даст правильную кодировку, все время будут иероглифы !!
    // в итого в Jenkins на Windows нужно запускать oscript без -encoding=utf-8  

    def commandToRun = "oscript finder.os";
    dir('tests') {
        cmd(commandToRun)
    }

    step([$class: 'JUnitResultArchiver', testResults: '**/tests/*.xml'])

    stage "checkout 1bdd"

    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: '1bdd']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/artbear/1bdd.git']]])

    stage "exec gitsync features"

    command = """oscript ./1bdd/src/bdd.os ./src/gitsync/features -out ./bdd-exec.log"""

    def errors = []
    try{
        cmd(command)
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

def cmd(command) {
    // TODO при запуске Jenkins не в режиме UTF-8 нужно написать chcp 1251 вместо chcp 65001
    if (isUnix()){ sh "${command}" } else {bat "chcp 65001\n${command}"}
}