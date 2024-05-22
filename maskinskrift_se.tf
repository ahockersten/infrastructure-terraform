resource "cloudflare_zone" "maskinskrift_se" {
  paused = false
  plan   = "free"
  type   = "full"
  zone   = "maskinskrift.se"
}

resource "cloudflare_record" "terraform_managed_resource_59b3c25e226af5efaf049bd13944eacb" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm1.maskinskrift.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_se.id
}

resource "cloudflare_record" "terraform_managed_resource_bdcf5c61057f752e38815eba05119b98" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm2.maskinskrift.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_se.id
}

resource "cloudflare_record" "terraform_managed_resource_a1fb7b321ada485bbda592d7ae5ade55" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm3.maskinskrift.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_se.id
}

resource "cloudflare_record" "terraform_managed_resource_c94ffe8fb895adac6f33937dd8c9f6c3" {
  name     = "maskinskrift.se"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.maskinskrift_se.id
}

resource "cloudflare_record" "terraform_managed_resource_0bb043a3ec43ff3d8e46a15f29ac87e4" {
  name     = "maskinskrift.se"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.maskinskrift_se.id
}

resource "cloudflare_record" "terraform_managed_resource_3d37f9bb971f0085b72ac275607b0c33" {
  name    = "maskinskrift.se"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=spf1 include:spf.messagingengine.com ?all"
  zone_id = cloudflare_zone.maskinskrift_se.id
}
