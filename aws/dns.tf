
# Created by AWS Registrar
# resource "aws_route53_zone" "cookson_pro" {
#   name = "cookson.pro"
# }

data "aws_route53_zone" "cookson_pro" {
  name = "cookson.pro"
}

resource "aws_route53_record" "cookson_pro_soa" {
  zone_id = data.aws_route53_zone.cookson_pro.zone_id
  name    = "cookson.pro"
  type    = "SOA"
  ttl     = 900
  records = [
    "ns-1930.awsdns-49.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400",
  ]
}

resource "aws_route53_record" "ns" {
  zone_id = data.aws_route53_zone.cookson_pro.zone_id
  name    = "cookson.pro"
  type    = "NS"
  ttl     = 172800
  records = [
    "ns-1930.awsdns-49.co.uk.",
    "ns-1007.awsdns-61.net.",
    "ns-1354.awsdns-41.org.",
    "ns-122.awsdns-15.com."
  ]
}

variable "azure_name_servers" {
  type = list(string)
  default = [
    "ns1-08.azure-dns.com.",
    "ns2-08.azure-dns.net.",
    "ns3-08.azure-dns.org.",
    "ns4-08.azure-dns.info."
    ]
}

resource "aws_route53_record" "az_ns" {
  zone_id = data.aws_route53_zone.cookson_pro.zone_id
  name    = "az.cookson.pro"
  type    = "NS"
  ttl     = 172800
  records = var.azure_name_servers
}

resource "aws_route53_record" "az_soa" {
  zone_id = data.aws_route53_zone.cookson_pro.zone_id
  name    = "az.cookson.pro"
  type    = "SOA"
  ttl     = 3600
  records = [
    "ns1-08.azure-dns.com. azuredns-hostmaster.microsoft.com. 1 3600 300 2419200 3600",
  ]
}

