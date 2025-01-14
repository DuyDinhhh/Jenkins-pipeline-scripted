@Library(['share_library_build', 'share_library_test', 'share_library_deploy']) _
node {
    // Define environment variables
    env.SCANNER_HOME = tool 'sonar-scanner'
    env.NEXUS_URL = '192.168.66.6:8081'
    env.NEXUS_CREDENTIALS_ID = 'for-nexus'
    env.NEXUS_REPOSITORY = 'maven-releases'
    env.NEXUS_GROUP = 'com/javaproject'
    env.NEXUS_ARTIFACT_ID = 'database_service_project'
    env.ARTIFACT_VERS = "1.${env.BUILD_ID}"
    def branch = env.BRANCH_NAME

    // Node 01: Build and Test
    node('node-01') {
        stage('Checkout Code') {
            checkOutSCM()
        }
        stage('Build Application') {
            buildSpringboot()
        }
        stage('Unit Testing') {
            unitTestJava()
        }
        stage('Code Quality Analysis') {
            qualitySonarCheck()
        }
        if (branch == 'main' || branch.startsWith('uat')) {
            stage('Package Application') {
                packageSpringboot()
            }
            stage('Push Artifact to Nexus') {
                pushArtifactNexusJava()
            }
        }
    }

    // Node 02: Deployment
    if (branch == 'main' || branch.startsWith('uat')) {
        node('node-02') {
            stage('Pull Artifact from Nexus') {
                pullArtifactNexusJava()
            }
            stage('Deploy Application') {
                deployJava()
            }
            stage('Health Check') {
                healthCheck()
            }
        }
    }
}
