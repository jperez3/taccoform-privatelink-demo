module "tostada" {
    source = "../../../modules/tostada"

    env                = "prod"
    public_domain_name = "tacoform.com"
    # vpc_name           = "provider-prod"
}


# module.tostada.aws_vpc_endpoint.privatelink: Creating...
# ╷
# │ Error: Error creating VPC Endpoint: InvalidParameter: Private DNS can't be enabled because the service com.amazonaws.vpce.us-east-2.vpce-svc-0e15fb8cd7298a000 has not verified the private DNS name.
# │       status code: 400, request id: ac88b523-b99d-4b48-8c12-26b18893ce3f
# │
# │   with module.tostada.aws_vpc_endpoint.privatelink,
# │   on ../../../modules/tostada/privatelink.tf line 81, in resource "aws_vpc_endpoint" "privatelink":
# │   81: resource "aws_vpc_endpoint" "privatelink" {
# │


# To verify ownership, add a TXT record to your domain's DNS server using specified verification name and value before proceeding.
# Note: The verification process may take up to 10 minutes.
