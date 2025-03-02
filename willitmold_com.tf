resource "cloudflare_zone" "willitmold_com" {
  account_id = "112de8987d83411a2230c9d9f52bbe09"
  paused     = false
  plan       = "free"
  type       = "full"
  zone       = "willitmold.com"
}

resource "cloudflare_record" "willitmold_com" {
  name    = "@"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  content = "will-it-mold.pages.dev"
  zone_id = cloudflare_zone.willitmold_com.id
}

resource "cloudflare_record" "www_willitmold_com" {
  name    = "www"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  content = "will-it-mold.pages.dev"
  zone_id = cloudflare_zone.willitmold_com.id
}

resource "cloudflare_record" "mx1_willitmold_com" {
  name     = "@"
  proxied  = false
  priority = 10
  ttl      = 1
  type     = "MX"
  content  = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.willitmold_com.id
}

resource "cloudflare_record" "mx2_willitmold_com" {
  name     = "@"
  proxied  = false
  priority = 20
  ttl      = 1
  type     = "MX"
  content  = "in2-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.willitmold_com.id
}

resource "cloudflare_record" "dkim1_willitmold_com" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm1.willitmold.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.willitmold_com.id
}

resource "cloudflare_record" "dkim2_willitmold_com" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm2.willitmold.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.willitmold_com.id
}

resource "cloudflare_record" "dkim3_willitmold_com" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm3.willitmold.com.dkim.fmhosted.com"
  zone_id = cloudflare_zone.willitmold_com.id
}

resource "cloudflare_record" "spf_willitmold_com" {
  name    = "@"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "v=spf1 include:spf.messagingengine.com ?all"
  zone_id = cloudflare_zone.willitmold_com.id
}
