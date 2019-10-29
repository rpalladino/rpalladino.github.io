provider "aws" {
    profile = "default"
    region  = "us-west-2"
}

provider "aws" {
    profile = "default"
    region  = "us-east-1"
    alias   = "us_east_1"
}

variable "root_domain_name" {
    default = "roccopalladino.com"
}

resource "aws_route53_zone" "main" {
    name = "${var.root_domain_name}"
}

resource "aws_acm_certificate" "cert" {
    provider    = "aws.us_east_1"
    domain_name = "${var.root_domain_name}"
    subject_alternative_names = ["*.${var.root_domain_name}"]
    validation_method = "DNS"
}

resource "aws_s3_bucket" "root" {
    bucket = "${var.root_domain_name}"
    region = "us-west-2"
    acl    = "public-read"

    website {
        index_document = "index.html"
    }

    logging {
        target_bucket = "logs.${var.root_domain_name}"
        target_prefix = "root/"
    }
}

resource "aws_s3_bucket_policy" "root" {
    bucket = "${var.root_domain_name}"
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.root_domain_name}/*"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket" "www" {
    bucket = "www.${var.root_domain_name}"
    acl    = "public-read"

    website {
        redirect_all_requests_to = "${var.root_domain_name}"
    }
}

resource "aws_s3_bucket" "logs" {
    bucket = "logs.${var.root_domain_name}"
    acl    = "private"
}
