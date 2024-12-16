
# Create CloudFront Origin Access Identity (OAI)
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for cwcloudresume"
}

# Creates a CloudFront Distribution
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.website_index_document

  origin {
    domain_name = aws_s3_bucket.cw_resume_s3.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.cw_resume_s3.id}"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.oai.id}"
    }
  }

  aliases = [var.domain_name, var.secondary_domain_name]

  default_cache_behavior {
    target_origin_id       = "S3-${aws_s3_bucket.cw_resume_s3.id}"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.issued.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }


  depends_on = [aws_s3_bucket.cw_resume_s3]
}


# Use ACM Certificate already issued
data "aws_acm_certificate" "issued" {
  domain   = "cwcloudresume.me"
  statuses = ["ISSUED"]
}

# Use Domain Name thats in route 53
resource "aws_route53_record" "alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_cloudfront_distribution.cdn]
}

resource "aws_route53_record" "alias_secondary" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.secondary_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# Route 53 Zone data
data "aws_route53_zone" "primary" {
  name = var.domain_name
}

