moved {
  from = cloudflare_zone.terraform_managed_resource_7a6cc4008e17157d1c4d1bbd05559f12
  to   = cloudflare_zone.hoeckersten_se
}

resource "cloudflare_zone" "hoeckersten_se" {
  paused = false
  plan   = "free"
  type   = "full"
  zone   = "höckersten.se"
}

resource "cloudflare_record" "terraform_managed_resource_736e6a4a3c2667a4c754e5a5608f1e0f" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm1.xn--hckersten-07a.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_record" "terraform_managed_resource_2bcefad424bdbfed5b4a77ee06bbd194" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm2.xn--hckersten-07a.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_record" "terraform_managed_resource_fa4f4c05b39d5647083c1be0ea154ba8" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm3.xn--hckersten-07a.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_record" "terraform_managed_resource_d0a1368a33e4130d91453fdc3d206c27" {
  name     = "xn--hckersten-07a.se"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_record" "terraform_managed_resource_2bcbf64fdcab6c164d5b09f3baf87971" {
  name     = "xn--hckersten-07a.se"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_record" "terraform_managed_resource_15b5a5e062a88adcfc6e921c340b0629" {
  name    = "xn--hckersten-07a.se"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=spf1 include:spf.messagingengine.com ?all"
  zone_id = cloudflare_zone.hoeckersten_se.id
}
