# Demo Rancher on Digital Ocean managed by Terraform

    2020 Ondrej Sika <ondrej@ondrejsika.com>
    https://github.com/ondrejsika/terraform-do-rancher-example


## Run Server

```
terraform init
terraform plan
terraform apply -auto-approve
```

## Connect

```
ssh root@rancher.sikademo.com
```


## Destroy Infrastructure

```
terraform destroy -auto-approve
```
