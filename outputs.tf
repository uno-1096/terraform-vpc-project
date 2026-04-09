output "terraform_course_vpc_id" {
  value = aws_vpc.terraform_course.id
}

output "development_vpc_id" {
  value = aws_vpc.development.id
}

output "homelab_public_ip" {
  value = aws_eip.homelab.public_ip
}
