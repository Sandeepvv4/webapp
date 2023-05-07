pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'ap-southeast-2'
    }
    parameters {
        string(name: 'AWS_REGION', description: 'The AWS region to deploy resources to', defaultValue: 'ap-southeast-2')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select the Terraform action to perform')
    }
    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }
        stage('Terraform Action') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    credentialsId: 'aws_credential',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    script {
                switch (params.ACTION) {
                    case 'plan':
                        sh 'terraform plan'
                        break
                    case 'apply':
                        sh 'terraform apply -auto-approve'
                        sh '''
                            ssh -i ${var.key_name}.pem ec2-user@${aws_instance.my-instance.public_ip} "sudo yum update -y"
                            ssh -i ${var.key_name}.pem ec2-user@${aws_instance.my-instance.public_ip} "sudo yum install -y docker"
                            ssh -i ${var.key_name}.pem ec2-user@${aws_instance.my-instance.public_ip} "sudo systemctl start docker"
                            scp -i ${var.key_name}.pem /home/sandeep/myapp/myapp.war ec2-user@${aws_instance.my-instance.public_ip}:/home/ec2-user/myapp.war
							#scp -i ${var.key_name}.pem /path/to/local/Dockerfile ec2-user@${aws_instance.my-instance.public_ip}:/home/ec2-user/
                            ssh -i ${var.key_name}.pem ec2-user@${aws_instance.my-instance.public_ip} "sudo docker build -t my-tomcat-app /home/ec2-user/"
                            ssh -i ${var.key_name}.pem ec2-user@${aws_instance.my-instance.public_ip} "sudo docker run -d -p 8080:8080 my-tomcat-app"
                        '''
                        break
                    case 'destroy':
                        sh 'terraform destroy -auto-approve'
                        break
                    default:
                        error "Invalid Terraform action selected: ${params.ACTION}"
                        }
                    }
                }
             }
        }
    }
}
