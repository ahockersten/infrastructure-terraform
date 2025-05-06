resource "cloudflare_zone" "maskinskrift_com" {
  account = {
    id = "112de8987d83411a2230c9d9f52bbe09"
  }
  type = "full"
  name = "maskinskrift.com"
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_bb10d33ddc80e9103c365af22963b287
  to   = cloudflare_dns_record.dkim1_maskinskrift_com
}

resource "cloudflare_dns_record" "dkim1_maskinskrift_com" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm1.maskinskrift.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_com.id
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_23a4e51f725d9f4a3092f941d4c5b9ee
  to   = cloudflare_dns_record.dkim2_maskinskrift_com
}

resource "cloudflare_dns_record" "dkim2_maskinskrift_com" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm2.maskinskrift.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_com.id
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_ac15d6f6a7a06337aa25fac3cf3bdb4e
  to   = cloudflare_dns_record.dkim3_maskinskrift_com
}

resource "cloudflare_dns_record" "dkim3_maskinskrift_com" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm3.maskinskrift.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_com.id
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_02c3c566681539936ddaf0c51209246b
  to   = cloudflare_dns_record.www_maskinskrift_com
}

resource "cloudflare_dns_record" "www_maskinskrift_com" {
  name    = "www"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "d2jviw1g1h6zo.cloudfront.net"
  zone_id = cloudflare_zone.maskinskrift_com.id
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_3e61b9c365eebd6bf736cc5d9b87c87d
  to   = cloudflare_dns_record.mx2_maskinskrift_com
}

resource "cloudflare_dns_record" "mx2_maskinskrift_com" {
  name     = "maskinskrift.com"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in2-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.maskinskrift_com.id
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_48ddc96f82527a88d9089288495e1f00
  to   = cloudflare_dns_record.mx1_maskinskrift_com
}

resource "cloudflare_dns_record" "mx1_maskinskrift_com" {
  name     = "maskinskrift.com"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.maskinskrift_com.id
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_0db45f3563046967849f689f6424cde5
  to   = cloudflare_dns_record.spf_maskinskrift_com
}

resource "cloudflare_dns_record" "spf_maskinskrift_com" {
  name    = "maskinskrift.com"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "\"v=spf1 include:spf.messagingengine.com ?all\""
  zone_id = cloudflare_zone.maskinskrift_com.id
}
