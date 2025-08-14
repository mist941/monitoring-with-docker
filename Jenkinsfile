pipeline {
	agent any

	options {
		timestamps()
		ansiColor('xterm')
		buildDiscarder(logRotator(numToKeepStr: '10'))
	}

	environment {
		SSH_CREDENTIALS_ID = '223fadd2-af92-42a5-aa03-09a41c4f8543'
		DEPLOY_HOST        = '192.168.88.76'
		DEPLOY_USER        = 'admin'
		DEPLOY_PATH        = '/home/admin/monitoring-with-docker'
	}

	stages {
		stage('Checkout') {
			steps {
				checkout scm
			}
		}

		stage('Prepare remote directory') {
			when { branch 'master' }
			steps {
				sshagent(credentials: [env.SSH_CREDENTIALS_ID]) {
					sh '''
            ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} "mkdir -p ${DEPLOY_PATH}"
          '''
				}
			}
		}

		stage('Sync files to server') {
			when { branch 'master' }
			steps {
				sshagent(credentials: [env.SSH_CREDENTIALS_ID]) {
					sh '''
            RSYNC_RSH='ssh -o StrictHostKeyChecking=no'
            rsync -az --delete --exclude='.git/' --exclude='.github/' -e "$RSYNC_RSH" ./ ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH}/
          '''
				}
			}
		}

        stage('Deploy with docker-compose') {
        	when { branch 'master' }
        	steps {
        		sshagent(credentials: [env.SSH_CREDENTIALS_ID]) {
        			sh '''
                ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} "bash -lc 'cd ${DEPLOY_PATH}; chmod +x ./deploy.sh || true; ./deploy.sh .'"
              '''
        		}
        	}
        }
	}

	post {
		always {
			cleanWs()
		}
	}
}