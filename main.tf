provider "aws" {
  region = "eu-west-2"
}
resource "aws_db_instance" "example-db"{
    identifier_prefix="postgres-mvjr"
    engine="postgres"
    allocated_storage=10
    instance_class="db.t3.micro"
    name="pgtest"
    //username=local.db_creds.username
    //password =local.db_creds.password
    username="qliksense"
    password = aws_ssm_parameter.db-password-param.value
    skip_final_snapshot  = true
}

resource "random_password" "db-password" {
    length = 16
    special = true
    override_special = "_-"
  
}
resource "aws_ssm_parameter" "db-password-param" {
    name = "/test/postgres/password"
    type = "SecureString"
    value = "${random_password.db-password.result}"
    description = "postgres password"
  
}

resource "null_resource" "setup_db" {
  depends_on = ["aws_db_instance.example-db"] #wait for the db to be ready
    provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = "/tmp"
    command     = <<-EOT
        #!/bin/bash
        sudo yum update -y
        sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-6-x86_64/pgdg-redhat-repo-latest.noarch.rpm
        sudo yum install postgresql -y
        export PGPASSWORD = ${aws_ssm_parameter.db-password-param.value}
        psql --host=${aws_db_instance.example-db.endpoint} --port=5432 --username=qliksense --dbname=pgtest < pgsql.sql
    EOT
    }
}