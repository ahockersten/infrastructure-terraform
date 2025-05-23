resource "cloudflare_zone" "orbmit_org" {
  account = {
    id = "112de8987d83411a2230c9d9f52bbe09"
  }
  type = "full"
  name = "orbmit.org"
}

#resource "cloudflare_record" "terraform_managed_resource_4c2a115853b896bb4c33d2cddfb2822c" {
#  name    = "alexandria"
#  proxied = false
#  ttl     = 1
#  type    = "A"
#  content = "98.128.175.95"
#  zone_id = cloudflare_zone.orbmit_org.id
#}
#
#resource "cloudflare_record" "terraform_managed_resource_31df9688a32591a135f0c6efde1722e0" {
#  name    = "alexandria"
#  proxied = false
#  ttl     = 1
#  type    = "AAAA"
#  content = "2001:9b1:26fa:1900:7285:c2ff:fe70:895c"
#  zone_id = cloudflare_zone.orbmit_org.id
#}
#
#resource "cloudflare_record" "wwwa" {
#  name    = "www"
#  proxied = false
#  ttl     = 1
#  type    = "A"
#  content = "98.128.175.95"
#  zone_id = cloudflare_zone.orbmit_org.id
#}
#
#resource "cloudflare_record" "wwwaaaa" {
#  name    = "www"
#  proxied = false
#  ttl     = 1
#  type    = "AAAA"
#  content = "2001:9b1:26fa:1900:7285:c2ff:fe70:895c"
#  zone_id = cloudflare_zone.orbmit_org.id
#}

resource "cloudflare_dns_record" "dkim1_orbmit_org" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm1.orbmit.org.dkim.fmhosted.com"
  zone_id = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_dns_record" "dkim2_orbmit_org" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm2.orbmit.org.dkim.fmhosted.com"
  zone_id = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_dns_record" "dkim3_orbmit_org" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  content = "fm3.orbmit.org.dkim.fmhosted.com"
  zone_id = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_dns_record" "mx2_orbmit_org" {
  name     = "orbmit.org"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in2-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_dns_record" "mx1_orbmit_org" {
  name     = "orbmit.org"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  content  = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_dns_record" "spf_orbmit_org" {
  name    = "orbmit.org"
  proxied = false
  ttl     = 1
  type    = "TXT"
  content = "\"v=spf1 include:spf.messagingengine.com ?all\""
  zone_id = cloudflare_zone.orbmit_org.id
}
