resource "cloudflare_zone" "hockersten_se" {
  account = {
    id = "112de8987d83411a2230c9d9f52bbe09"
  }
  type = "full"
  name = "hockersten.se"
}

resource "cloudflare_dns_record" "dkim1_hockersten_se" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm1.hockersten.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hockersten_se.id
}

resource "cloudflare_dns_record" "dkim2_hockersten_se" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm2.hockersten.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hockersten_se.id
}

resource "cloudflare_dns_record" "dkim3_hockersten_se" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm3.hockersten.se.dkim.fmhosted.com"
  zone_id = cloudflare_zone.hockersten_se.id
}

resource "cloudflare_dns_record" "mx1_hockersten_se" {
  name     = "hockersten.se"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.hockersten_se.id
}

resource "cloudflare_dns_record" "mx2_hockersten_se" {
  name     = "hockersten.se"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in2-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.hockersten_se.id
}

resource "cloudflare_dns_record" "spf_hockersten_se" {
  name    = "hockersten.se"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "\"v=spf1 include:spf.messagingengine.com ?all\""
  zone_id = cloudflare_zone.hockersten_se.id
}

resource "cloudflare_dns_record" "hockersten_se_google_site_verification" {
  name    = "hockersten.se"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  content = "\"google-site-verification=VP2XBnOcA-avhb_Nyp__WF-0AUSHtAIp-1JDfXTUQ58\""
  zone_id = cloudflare_zone.hockersten_se.id
}

resource "cloudflare_dns_record" "brevo_code" {
  name    = "@"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  content = "\"brevo-code:adac91212964ad00fd332cb49559c2db\""
  zone_id = cloudflare_zone.hockersten_se.id
}

resource "cloudflare_dns_record" "brevo_dkim_1" {
  name    = "brevo1._domainkey"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  content = "b1.hockersten-se.dkim.brevo.com"
  zone_id = cloudflare_zone.hockersten_se.id
}

resource "cloudflare_dns_record" "brevo_dkim_2" {
  name    = "brevo2._domainkey"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  content = "b2.hockersten-se.dkim.brevo.com"
  zone_id = cloudflare_zone.hockersten_se.id
}

resource "cloudflare_dns_record" "brevo_dmarc" {
  name    = "_dmarc"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  content = "\"v=DMARC1; p=none; rua=mailto:rua@dmarc.brevo.com\""
  zone_id = cloudflare_zone.hockersten_se.id
}
