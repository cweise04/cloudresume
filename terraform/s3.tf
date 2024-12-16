
# Create S3 bucket
resource "aws_s3_bucket" "cw_resume_s3" {
  bucket = var.cw_resume_s3
}

# enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "cw_s3_versioning" {
  bucket = aws_s3_bucket.cw_resume_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create the bucket policy for the S3 bucket so the s3 website can be accessed
resource "aws_s3_bucket_policy" "cwcloudresume_bucket_policy" {
  bucket = aws_s3_bucket.cw_resume_s3.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "arn:aws:s3:::${aws_s3_bucket.cw_resume_s3.bucket}/*"
      }
    ]
  })
}

# Create the CORS for the S3 Bucket
resource "aws_s3_bucket_cors_configuration" "cw_resume_s3_cors" {
  bucket = aws_s3_bucket.cw_resume_s3.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://cwcloudresume.me"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# Allow the public access to be off for making the s3 bucket public
resource "aws_s3_bucket_public_access_block" "cw_resume_s3_public" {
  bucket                  = aws_s3_bucket.cw_resume_s3.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Output the variable for the s3 bucket name so other resources can reference it
output "bucket_id" {
  value = aws_s3_bucket.cw_resume_s3.id
}

# Create a static website in the S3 bucket
resource "aws_s3_bucket_website_configuration" "cw_resume_website" {
  bucket = aws_s3_bucket.cw_resume_s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

 # lines 73-35 Allow uploading of webstie files into the S3 bucket automatically
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.cw_resume_s3.id
  key          = "index.html"
  source       = "${path.module}/website/index.html"
  etag         = filemd5("${path.module}/website/index.html")
  content_type = "text.html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.cw_resume_s3.id
  key          = "404.html"
  source       = "${path.module}/website/404.html"
  etag         = filemd5("${path.module}/website/404.html")
  content_type = "text.html"
}

resource "aws_s3_object" "css" {
  bucket       = aws_s3_bucket.cw_resume_s3.id
  key          = "styles.css"
  source       = "${path.module}/website/styles.css"
  etag         = filemd5("${path.module}/website/styles.css")
  content_type = "text.css"
}

resource "aws_s3_object" "aws_cert_dev" {
  bucket       = aws_s3_bucket.cw_resume_s3.id
  key          = "aws_dev.png"
  etag         = filemd5("${path.module}/website/aws_dev.png")
  content_type = "text.png"
}

resource "aws_s3_object" "aws_cert_sa" {
  bucket       = aws_s3_bucket.cw_resume_s3.id
  key          = "aws_sa.png"
  source       = "${path.module}/website/aws_sa.png"
  etag         = filemd5("${path.module}/website/aws_sa.png")
  content_type = "text.png"
}

resource "aws_s3_object" "azure_cert_fun" {
  bucket       = aws_s3_bucket.cw_resume_s3.id
  key          = "azure_fun.png"
  source       = "${path.module}/website/azure_fun.png"
  etag         = filemd5("${path.module}/website/azure_fun.png")
  content_type = "text.png"
}

resource "aws_s3_object" "pic_me" {
  bucket       = aws_s3_bucket.cw_resume_s3.id
  key          = "me.JPEG"
  source       = "${path.module}/website/me.JPEG"
  etag         = filemd5("${path.module}/website/me.JPEG")
  content_type = "text.JPEG"
}

resource "aws_s3_object" "JS_Counter" {
  bucket = aws_s3_bucket.cw_resume_s3.id
  key    = "counter.js"
 source = "${path.module}/website/js/counter.js"
  etag   = filemd5("${path.module}/website/js/counter.js")
  content_type = "application/javascript"
}

# Uploads automatically for Lambda Python code
resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.cw_resume_s3.id
  key    = "lambda.zip"
  source = "${path.module}/lambda.zip"
  etag   = filemd5("${path.module}/lambda.zip")
}

