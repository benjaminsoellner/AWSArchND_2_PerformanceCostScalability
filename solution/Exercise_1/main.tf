# designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "???"
  secret_key = "???"
  token = "???"
  region = "us-east-1"
}

# provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity_T2" {
  count = "4"
  ami = "ami-0279c3b3186e54acd"
  instance_type = "t2.micro"
  tags = {
      Name = "Udacity T2"
  }
  subnet_id = "subnet-01a96d46ac6987a2c"
}

# provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity_M4" {
  count = "2"
  ami = "ami-0279c3b3186e54acd"
  instance_type = "m4.large"
  tags = {
      Name = "Udacity M4"
  }
  subnet_id = "subnet-01a96d46ac6987a2c"
}
