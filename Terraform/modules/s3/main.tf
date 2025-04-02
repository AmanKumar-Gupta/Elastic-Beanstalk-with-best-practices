resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
  
  block_public_acls       = var.block_public_access
  block_public_policy     = var.block_public_access
  ignore_public_acls      = var.block_public_access
  restrict_public_buckets = var.block_public_access
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count  = var.enable_cors ? 1 : 0
  bucket = aws_s3_bucket.this.id
  
  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.enable_lifecycle_rules ? 1 : 0
  bucket = aws_s3_bucket.this.id
  
  rule {
    id     = "transition-to-standard-ia"
    status = "Enabled"
    
    filter {
      prefix = "" # For the entire bucket
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
  
  rule {
    id     = "transition-to-glacier"
    status = "Enabled"
    
    filter {
      prefix = "" # For the entire bucket
    }
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
  
  rule {
    id     = "expiration"
    status = "Enabled"
    
  filter {
    prefix = "" # For the entire bucket
  }
  
    expiration {
      days = 365
    }
  }
}