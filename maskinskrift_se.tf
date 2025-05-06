resource "cloudflare_zone" "maskinskrift_se" {
  account = {
    id = "112de8987d83411a2230c9d9f52bbe09"
  }
  type = "full"
  name = "maskinskrift.se"
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_59b3c25e226af5efaf049bd13944eacb
  to   = cloudflare_dns_record.dkim1_maskinskrift_se
}

resource "cloudflare_dns_record" "dkim1_maskinskrift_se" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm1.maskinskrift.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_se.id
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_bdcf5c61057f752e38815eba05119b98
  to   = cloudflare_dns_record.dkim2_maskinskrift_se
}

resource "cloudflare_dns_record" "dkim2_maskinskrift_se" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm2.maskinskrift.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_se.id
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_a1fb7b321ada485bbda592d7ae5ade55
  to   = cloudflare_dns_record.dkim3_maskinskrift_se
}

resource "cloudflare_dns_record" "dkim3_maskinskrift_se" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm3.maskinskrift.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_se.id
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_c94ffe8fb895adac6f33937dd8c9f6c3
  to   = cloudflare_dns_record.mx2_maskinskrift_se
}

resource "cloudflare_dns_record" "mx2_maskinskrift_se" {
  name     = "maskinskrift.se"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in2-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.maskinskrift_se.id
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_0bb043a3ec43ff3d8e46a15f29ac87e4
  to   = cloudflare_dns_record.mx1_maskinskrift_se
}

resource "cloudflare_dns_record" "mx1_maskinskrift_se" {
  name     = "maskinskrift.se"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.maskinskrift_se.id
}

moved {
  from = cloudflare_dns_record.terraform_managed_resource_3d37f9bb971f0085b72ac275607b0c33
  to   = cloudflare_dns_record.spf_maskinskrift_se
}

resource "cloudflare_dns_record" "spf_maskinskrift_se" {
  name    = "maskinskrift.se"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "\"v=spf1 include:spf.messagingengine.com ?all\""
  zone_id = cloudflare_zone.maskinskrift_se.id
}
