pipeline {
  agent any

  tools {
    terraform 'terraform-iti'
    ansible 'ansible-iti'
  }

  stages {
    stage('Terraform Init') {
      steps {
        dir('terraform') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('terraform') {
          sh 'terraform apply -auto-approve'
          sleep 60
        }
      }
    }

    stage('Get EC2 IP') {
      steps {
        script {
          def ip = sh(script: "cd terraform && terraform output -raw public_ip", returnStdout: true).trim()
          writeFile file: 'ansible/hosts', text: "${ip} ansible_user=ec2-user ansible_ssh_private_key_file=.ssh/jenkins.pem" 
        }
      }
    }

   stage('Run Ansible Playbook') {
  steps {
    withCredentials([sshUserPrivateKey(credentialsId: 'my-ec2-key', keyFileVariable: 'SSH_KEY')]) {
      sh '''
        echo "[ec2] $(cat ansible/hosts)" > ansible/hosts
        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/hosts ansible/playbook.yml \
          --private-key=$SSH_KEY
      '''
    }
  }
}
