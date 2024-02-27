resource "aws_wafv2_ip_set" "ip_set" {
  provider           = aws.virginia
  name               = "allow-ip-set"
  description        = "allow ip set"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses = [
    "116.0.0.0/6",
    "116.82.102.140/32",
    "113.43.73.18/32"
  ]
}

resource "aws_wafv2_web_acl" "web_acl" {
  provider    = aws.virginia
  name        = "only-from-allow-ip-set"
  description = "Web ACL that blocks all traffic except for a allow IP set"
  scope       = "CLOUDFRONT"
  default_action {
    block {}
  }

  rule {
    name     = "allow-ips-in-ip_set"
    priority = 1
    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_set.arn
      }
    }

    visibility_config {
      sampled_requests_enabled   = false
      cloudwatch_metrics_enabled = false
      metric_name                = "wordpress-allow-ips-in-ip_set"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "wordpress-wafv2-web-acl"
    sampled_requests_enabled   = false
  }
}
