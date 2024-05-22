moved {
  from = cloudflare_zone.terraform_managed_resource_dd81a0b6777f3c28906be028734a53bd
  to   = cloudflare_zone.orbmit_org
}

resource "cloudflare_zone" "orbmit_org" {
  paused = false
  plan   = "free"
  type   = "full"
  zone   = "orbmit.org"
}

resource "cloudflare_record" "terraform_managed_resource_4c2a115853b896bb4c33d2cddfb2822c" {
  name    = "alexandria"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "98.128.175.95"
  zone_id = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_record" "terraform_managed_resource_31df9688a32591a135f0c6efde1722e0" {
  name    = "alexandria"
  proxied = false
  ttl     = 1
  type    = "AAAA"
  value   = "2001:9b1:26fa:1900:7285:c2ff:fe70:895c"
  zone_id = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_record" "wwwa" {
  name    = "www"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "98.128.175.95"
  zone_id = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_record" "wwwaaaa" {
  name    = "www"
  proxied = false
  ttl     = 1
  type    = "AAAA"
  value   = "2001:9b1:26fa:1900:7285:c2ff:fe70:895c"
  zone_id = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_record" "terraform_managed_resource_2a97fa825df567175732d4d8c018c780" {
  name    = "fm1._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm1.orbmit.org.dkim.fmhosted.com"
  zone_id = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_record" "terraform_managed_resource_e82e916cf069d40a54af088f1759fd62" {
  name    = "fm2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm2.orbmit.org.dkim.fmhosted.com"
  zone_id = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_record" "terraform_managed_resource_e5926d9d899bcb5cf66cee4c6025b2e0" {
  name    = "fm3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "fm3.orbmit.org.dkim.fmhosted.com"
  zone_id = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_record" "terraform_managed_resource_c941ed3dcfc115da581b5a7f1d85c222" {
  name     = "orbmit.org"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "in2-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_record" "terraform_managed_resource_bb9d8de57f82edbbab8ba1f59aa25558" {
  name     = "orbmit.org"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "in1-smtp.messagingengine.com"
  zone_id  = cloudflare_zone.orbmit_org.id
}

resource "cloudflare_record" "terraform_managed_resource_96f9f6ddfcff08445f4e1a71dbbffdbe" {
  name    = "orbmit.org"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=spf1 include:spf.messagingengine.com ?all"
  zone_id = cloudflare_zone.orbmit_org.id
}
