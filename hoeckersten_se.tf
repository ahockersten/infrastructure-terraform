resource "cloudflare_zone" "hoeckersten_se" {
  account = {
    id = "112de8987d83411a2230c9d9f52bbe09"
  }
  type = "full"
  name = "höckersten.se"
}

resource "cloudflare_dns_record" "dkim1_hoeckersten_se" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm1.xn--hckersten-07a.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_dns_record" "dkim2_hoeckersten_se" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm2.xn--hckersten-07a.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_dns_record" "dkim3_hoeckersten_se" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm3.xn--hckersten-07a.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_dns_record" "mx1_hoeckersten_se" {
  name     = "xn--hckersten-07a.se"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_dns_record" "mx2_hoeckersten_se" {
  name     = "xn--hckersten-07a.se"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in2-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.hoeckersten_se.id
}

resource "cloudflare_dns_record" "spf_hoeckersten_se" {
  name    = "xn--hckersten-07a.se"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "\"v=spf1 include:spf.messagingengine.com ?all\""
  zone_id = cloudflare_zone.hoeckersten_se.id
}
