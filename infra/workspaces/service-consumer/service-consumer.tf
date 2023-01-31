module "service_consumer" {
    source = "../../modules/vpc-endpoint"

    env                = "prod"
    service            = "tostada"
    vpc_name           = "consumer-prod"
}
