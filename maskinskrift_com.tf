resource "cloudflare_zone" "maskinskrift_com" {
  paused = false
  plan   = "free"
  type   = "full"
  zone   = "maskinskrift.com"
}

resource "cloudflare_record" "terraform_managed_resource_bb10d33ddc80e9103c365af22963b287" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm1.maskinskrift.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_com.id
}

resource "cloudflare_record" "terraform_managed_resource_23a4e51f725d9f4a3092f941d4c5b9ee" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm2.maskinskrift.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_com.id
}

resource "cloudflare_record" "terraform_managed_resource_ac15d6f6a7a06337aa25fac3cf3bdb4e" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm3.maskinskrift.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_com.id
}

resource "cloudflare_record" "terraform_managed_resource_02c3c566681539936ddaf0c51209246b" {
  name    = "www"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "d2jviw1g1h6zo.cloudfront.net"
  zone_id = cloudflare_zone.maskinskrift_com.id
}

resource "cloudflare_record" "terraform_managed_resource_3e61b9c365eebd6bf736cc5d9b87c87d" {
  name     = "maskinskrift.com"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.maskinskrift_com.id
}

resource "cloudflare_record" "terraform_managed_resource_48ddc96f82527a88d9089288495e1f00" {
  name     = "maskinskrift.com"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.maskinskrift_com.id
}

resource "cloudflare_record" "terraform_managed_resource_0db45f3563046967849f689f6424cde5" {
  name    = "maskinskrift.com"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=spf1 include:spf.messagingengine.com ?all"
  zone_id = cloudflare_zone.maskinskrift_com.id
}
