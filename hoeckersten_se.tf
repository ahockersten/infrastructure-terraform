resource "cloudflare_zone" "hoeckersten_se" {
  account = {
    id = "112de8987d83411a2230c9d9f52bbe09"
  }
  type = "full"
  name = "höckersten.se"
}

resource "cloudflare_dns_record" "terraform_managed_resource_736e6a4a3c2667a4c754e5a5608f1e0f" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm1.xn--hckersten-07a.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_dns_record" "terraform_managed_resource_2bcefad424bdbfed5b4a77ee06bbd194" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm2.xn--hckersten-07a.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_dns_record" "terraform_managed_resource_fa4f4c05b39d5647083c1be0ea154ba8" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm3.xn--hckersten-07a.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_dns_record" "terraform_managed_resource_d0a1368a33e4130d91453fdc3d206c27" {
  name     = "xn--hckersten-07a.se"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_dns_record" "terraform_managed_resource_2bcbf64fdcab6c164d5b09f3baf87971" {
  name     = "xn--hckersten-07a.se"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in2-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_dns_record" "terraform_managed_resource_15b5a5e062a88adcfc6e921c340b0629" {
  name    = "xn--hckersten-07a.se"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "\"v=spf1 include:spf.messagingengine.com ?all\""
  zone_id = cloudflare_zone.hoeckersten_se.id
}
