# **Deploying a Secure AWS Infrastructure with Terraform**

## **Infrastructure Diagram**  
![CF-15 drawio](https://github.com/user-attachments/assets/49044663-ca13-4a11-9589-4ef3f2d5e3ed)


## **Challenge Requirements**
1. **AWS Free Tier Account**: All AWS services used must be within the [AWS Free Tier](https://aws.amazon.com/free/) to minimize costs.
2. **Terraform Installation on Local**: Use Terraform to manage and deploy the infrastructure. Starter Terraform files will be provided. To get started on Terraform you can use the Official [AWS Tutorials](https://developer.hashicorp.com/terraform/tutorials/aws-get-started) from HashiCorp
3. Draw.io

## **Infrastructure Details**
- **VPC**: Created a Virtual Private Cloud (VPC) with public and private subnets across 2azs.
- **EC2 Instances**: Deployed an EC2 instances with docker installed through user_data in the private & public subnet with an SG rule that restricts access.
- **S3 Bucket**: Set up an S3 bucket with encryption and appropriate IAM policies to store cloud trail logs.
- **Security Groups**: Defined security groups to control inbound and outbound traffic.
- **CloudTrail**: Enabled AWS CloudTrail for logging all API activities.
- **IAM Policies**: Created least privilege IAM roles and policies for cloudtrail to log to s3.

**Additional Terraform Files**
- **vpc.tf**: contains terraform code for vpc(subnets,route_tables,igw,etc)
- **provider.tf**: contains provider configuration access configured using aws configure
- **variables.tf**: contains dynamic inputs for terraform setup
- **cloudfront.tf**: contains cloudfront config
- **cloudtrail.tf**: contains cloudtrail setup

## **Security considerations**
I adhered to security best practices by doing the following:
- Not including access keys in provider.tf
- Ensuring Security groups are designed with least priveledge access.
- Layered security (defense in depth) in designing architecture.
- Logging using cloudtrail.
- Automated and repeatable deployments using terraform.
  
