module "tostada" {
    source = "../../../modules/tostada"

    env                = "prod"
    public_domain_name = "tacoform.com"
    vpc_name           = "provider-prod"
}
