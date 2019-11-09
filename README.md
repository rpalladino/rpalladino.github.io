# roccopalladino.com

This is my personal website, roccopalladino.com. Currently it is a simple static landing page. Its purpose is primarily for me to explore modern cloud technologies.

The first version of this site ran as a Docker container managed by Dokku running on a single Digital Ocean droplet. It managed security certificates using Let’s Encrypt and DNS records were managed at Digital Ocean. Its total cost was $5 per month, the price of the lowest capacity DO droplet.

The current version runs in AWS. It is comprised of the following resources:

- a Route 53 hosted zone, where all DNS records are managed
- three S3 buckets in the us-west-2 region:
	- one for storing the site content under the root domain
	- one for the www domain that simply redirects to root
	- one for storing logs
- a CloudFront distribution with the S3 buckets set as origins, primarily for TLS which S3 does not do for custom domains
- a certificate issued by Certificate Manager

These infrastructure resources are represented as code using Terraform configurations.

In addition, the code is stored in a repo on GitLab and it uses a pipeline to auto deploy site content changes to S3.

The total cost for this on AWS is $0.53 per month: the monthly price of a Route53 hosted zone ($0.50) plus tax. The cost-savings between AWS and DO is a reflection of the difference between _capacity_ and _metered-usage_ pricing models. At DO, I would pay $5 for the reserved compute capacity of the droplet, regardless of whether I used that capacity or not. At AWS, I pay primarily based on traffic coming to my site (usage), which is effectively non-existent. 
