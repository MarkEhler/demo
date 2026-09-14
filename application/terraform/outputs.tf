output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the AWS VPC."
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "ID of the public subnet."
}

output "ec2_instance_id" {
  value       = aws_instance.demo_vm.id
  description = "Instance ID of the Datadog EC2 host."
}

output "ec2_public_ip" {
  value       = aws_instance.demo_vm.public_ip
  description = "Public IP of the Datadog EC2 host."
}

output "eks_cluster_name" {
  value       = aws_eks_cluster.demo.name
  description = "Name of the Amazon EKS cluster."
}

output "eks_cluster_endpoint" {
  value       = aws_eks_cluster.demo.endpoint
  description = "Endpoint of the EKS control plane."
}

output "secret_name" {
  value       = aws_secretsmanager_secret.demo.name
  description = "Name of the AWS Secrets Manager secret for launch config."
}

output "infrastructure_identifiers_json" {
  value = jsonencode({
    vpc_id         = aws_vpc.main.id
    public_subnet  = aws_subnet.public.id
    ec2_instance_id = aws_instance.demo_vm.id
    ec2_public_ip  = aws_instance.demo_vm.public_ip
    eks_cluster_name = aws_eks_cluster.demo.name
    eks_cluster_endpoint = aws_eks_cluster.demo.endpoint
    secret_name    = aws_secretsmanager_secret.demo.name
  })
  description = "Core AWS deployment identifiers for automation."
}