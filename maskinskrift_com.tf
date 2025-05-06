resource "cloudflare_zone" "maskinskrift_com" {
  account = {
    id = "112de8987d83411a2230c9d9f52bbe09"
  }
  type = "full"
  name = "maskinskrift.com"
}

resource "cloudflare_dns_record" "dkim1_maskinskrift_com" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm1.maskinskrift.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_com.id
}

resource "cloudflare_dns_record" "dkim2_maskinskrift_com" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm2.maskinskrift.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_com.id
}

resource "cloudflare_dns_record" "dkim3_maskinskrift_com" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm3.maskinskrift.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.maskinskrift_com.id
}

resource "cloudflare_dns_record" "www_maskinskrift_com" {
  name    = "www"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "d2jviw1g1h6zo.cloudfront.net"
  zone_id = cloudflare_zone.maskinskrift_com.id
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

resource "cloudflare_dns_record" "mx1_maskinskrift_com" {
  name     = "maskinskrift.com"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.maskinskrift_com.id
}

resource "cloudflare_dns_record" "spf_maskinskrift_com" {
  name    = "maskinskrift.com"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "\"v=spf1 include:spf.messagingengine.com ?all\""
  zone_id = cloudflare_zone.maskinskrift_com.id
}
