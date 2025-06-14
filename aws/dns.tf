
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
    "ns-1930.awsdns-49.co.uk. awsdns-hostmaster.amazon.com. 2025061000 7200 900 1209600 86400",
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

variable "gcp_name_servers" {
  type = list(string)
  default = [
    "ns-cloud-c1.googledomains.com.",
    "ns-cloud-c2.googledomains.com.",
    "ns-cloud-c3.googledomains.com.",
    "ns-cloud-c4.googledomains.com."
  ]
}

resource "aws_route53_record" "gcp_ns" {
  zone_id = data.aws_route53_zone.cookson_pro.zone_id
  name    = "gcp.cookson.pro"
  type    = "NS"
  ttl     = 172800
  records = var.gcp_name_servers
}



