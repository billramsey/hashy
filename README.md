# Hash Service

```
Take as input a string message. Store the message and return its SHA256 hash.
Take as input a SHA256 hash. If that message has been previously stored, return the
message associated with that hash.
```

See it in use:

```
curl -X POST a4a0167a44715403187b305adf7f2a3f-637461337.us-east-1.elb.amazonaws.com/hashy/bob
81b637d8fcd2c6da6359e6963113a1170de795e4b725b84d1e0b4cfd9ec58ce9

curl a4a0167a44715403187b305adf7f2a3f-637461337.us-east-1.elb.amazonaws.com/hashy/81b637d8fcd2c6da6359e6963113a1170de795e4b725b84d1e0b4cfd9ec58ce9
bob%
```

Uses redis as a back end for storing hashes.


### Deploy Process

make sure to have AWS CLI, terraform, docker, and kubectl installed.

Update terraform/modules/eks/main.tf/cluster_endpoint_public_access = to true 
to allow connections.

`make apply # runs terraform.`

Get the ECR URL from AWS and update the Makefile and manifests/hashy-app.yml

`make build-push # builds the image.`

`make kubectl-login # adds a context to kubectl`

`make deploy # applies the kubernetes manifests`

To get the url for your service:
```
kubectl describe services hashy-service -n hashy
Take the info from LoadBalancer Ingress

...
LoadBalancer Ingress:     a4a0167a44715403187b305adf7f2a3f-637461337.us-east-1.elb.amazonaws.com
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
NodePort:                 <unset>  31079/TCP
Endpoints:                10.0.11.227:80
...
```


Finished:

1. Created AWS organization account.
2. Setup secondary account for sandbox.
3. added IAM Identity Center account allowing them to either be PowerUser or SystemAdministrator
4. Added vpc/eks cluster using aws terraform modules
5. Created Dockerfile and fastapi setup.
6. Added ECR to terraform.
7. added redis cache to vpc to allow to scale beyond single node.

Out of scope for time:
1. Secure by Bastion/SSM or setup vpn client for securing connection to clusters.
2. add password / restrict redis to just the hashy pods (secrets manager?)
3. Add environment variables for passing correct redis url/password.
4. move Terraform state to s3.
5. Further lock down permissions for individual services.
6. SSL/Domain Name/cloudfront URL.

## Some Resources I referenced

https://github.com/aws-samples/python-fastapi-demo-docker/blob/main/kubernetes/fastapi-app.yaml
https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/patterns/private-public-ingress/main.tf
https://fastapi.tiangolo.com/deployment/docker/#create-the-fastapi-code
https://github.com/Sirlawdin/fastapi-iac-monitoring

