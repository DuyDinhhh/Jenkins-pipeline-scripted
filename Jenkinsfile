@Library(['share_library_build', 'share_library_test', 'share_library_deploy']) _
node { 
    // Define environment variables
    env.NEXUS_URL = '192.168.66.6:8081'
    env.NEXUS_URL_DOCKER = '192.168.66.6:8082'
    env.NEXUS_CREDENTIALS_ID = 'for-nexus'
    env.NEXUS_REPOSITORY = 'maven-releases'
    env.NEXUS_GROUP = 'com/javaproject'
    env.NEXUS_ARTIFACT_ID = 'database_service_project'
    env.ARTIFACT_VERS = "1.${env.BUILD_ID}"
    
    def branch = env.BRANCH_NAME ?: 'unknown-branch'
    
    node ('JDK8'){
        checkOutSCM()
        buildSpringboot()
        unitTestJava()
        qualitySonarCheck()

        if(branch=='main' || branch.startsWith('uat'))
        {
            def gitCommit = env.GIT_COMMIT ?: 'unknownCommit'
            if(branch.startsWith('uat'))
            {
                env.DEPLOY_TAG = "${new Date().format('yyyyMMddHHmmss')}-uat-${gitCommit.substring(0, 7)}"
            }
            else
            {
                env.DEPLOY_TAG = "${new Date().format('yyyyMMddHHmmss')}-release"
            }
            packageSpringboot()
            pushArtifactNexusJava()
            // Docker lab
	    buildDockerNexus()
            pushDockerNexus()
        }
    }
    if(branch=='main' || branch.startsWith('uat')){
        node ('JDK17')
        {
            pullArtifactNexusJava()
            deployJava()
            //tagSCM()
            healthCheck()
        }
    }
}
