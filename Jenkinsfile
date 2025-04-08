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
          writeFile file: 'ansible/hosts', text: "${ip} ansible_user=ec2-user ansible_ssh_private_key_file=.ssh/id_rsa" 
        }
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        sh 'ansible-playbook -i ansible/hosts ansible/playbook.yml'
      }
    }
  }
}
