

resource "aws_route53_record" "mx" {
  zone_id        = data.aws_route53_zone.cookson_pro.zone_id
  name           = "cookson.pro"
  type           = "MX"
  ttl            = 300
  set_identifier = "ICloudmx"
  records = [
    "10 mx01.mail.icloud.com.",
    "10 mx02.mail.icloud.com."
  ]

  weighted_routing_policy {
    weight = 10
  }
}

resource "aws_route53_record" "icloud_spf" {
  zone_id                          = data.aws_route53_zone.cookson_pro.zone_id
  name                             = "cookson.pro"
  type                             = "TXT"
  ttl                              = 300
  set_identifier                   = "ICloudSPF"
  records                          = ["v=spf1 include:icloud.com ~all"]
  multivalue_answer_routing_policy = true
}

resource "aws_route53_record" "icloud_txt" {
  zone_id        = data.aws_route53_zone.cookson_pro.zone_id
  name           = "cookson.pro"
  type           = "TXT"
  ttl            = 300
  set_identifier = "ICloudTXT"

  records                          = ["apple-domain=E1i5yGARHynUmiUP"]
  multivalue_answer_routing_policy = true
}

resource "aws_route53_record" "icloud_dkim" {
  zone_id = data.aws_route53_zone.cookson_pro.zone_id
  name    = "sig1._domainkey.cookson.pro"
  type    = "CNAME"
  ttl     = 300
  records = ["sig1.dkim.cookson.pro.at.icloudmailadmin.com."]
}

