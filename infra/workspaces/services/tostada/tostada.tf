module "tostada" {
    source = "../../../modules/tostada"

    env                = "prod"
    public_domain_name = "tacoform.com"
    vpc_name           = "provider-prod"
}


module "consumer_vpce" {
    source = "../../../modules/vpc-endpoint"

    env                = "prod"
    service            = "tostada"
    vpc_name           = "consumer-prod"
}

# VPCE_SERVICE_ID=$(av terraform output -raw vpce_service_id)
# av aws ec2 start-vpc-endpoint-service-private-dns-verification --service-id $VPCE_SERVICE_ID --region us-east-2

# output "vpce_service_id" {
#     value = module.tostada.vpce_service_id
# }
