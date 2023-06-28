resource "aws_s3_bucket" "data" {
  # bucket is public
  # bucket is not encrypted
  # bucket does not have access logs
  # bucket does not have versioning
  bucket        = "${local.resource_prefix.value}-data"
  region        = "us-west-2"
  acl           = "private"
  force_destroy = true
  tags = {
    Name        = "${local.resource_prefix.value}-data"
    Environment = local.resource_prefix.value
    yor_trace   = "4b8b8568-b87b-453d-b6ff-0427b6fe97ff"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket" "data_log_bucket" {
  bucket = "data-log-bucket"
  tags = {
    yor_trace = "7380563c-c63d-46db-ba0a-1aa4b13e0adc"
  }
}

resource "aws_s3_bucket_logging" "data" {
  bucket = aws_s3_bucket.data.id

  target_bucket = aws_s3_bucket.data_log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_object" "data_object" {
  bucket = aws_s3_bucket.data.id
  region = "us-west-2"
  key    = "customer-master.xlsx"
  source = "resources/customer-master.xlsx"
  tags = {
    Name        = "${local.resource_prefix.value}-customer-master"
    Environment = local.resource_prefix.value
    yor_trace   = "7fad7c36-9dfe-4326-b1cf-ac4005639a79"
  }
}

resource "aws_s3_bucket" "financials" {
  # bucket is not encrypted
  # bucket does not have access logs
  # bucket does not have versioning
  bucket        = "${local.resource_prefix.value}-financials"
  region        = "us-west-2"
  acl           = "private"
  force_destroy = true
  tags = {
    Name        = "${local.resource_prefix.value}-financials"
    Environment = local.resource_prefix.value
    yor_trace   = "bbcb6931-0420-474d-a7b6-fe54ee9bde7f"
  }

}


resource "aws_s3_bucket" "financials_log_bucket" {
  bucket = "financials-log-bucket"
  tags = {
    yor_trace = "d7a1f835-994c-49db-8a6c-6967a139cc4d"
  }
}

resource "aws_s3_bucket_logging" "financials" {
  bucket = aws_s3_bucket.financials.id

  target_bucket = aws_s3_bucket.financials_log_bucket.id
  target_prefix = "log/"
}



resource "aws_s3_bucket_versioning" "financials" {
  bucket = aws_s3_bucket.financials.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "financials" {
  bucket = aws_s3_bucket.financials.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket" "operations" {
  # bucket is not encrypted
  # bucket does not have access logs
  bucket = "${local.resource_prefix.value}-operations"
  region = "us-west-2"
  acl    = "private"
  versioning {
    enabled = true
  }
  force_destroy = true
  tags = {
    Name        = "${local.resource_prefix.value}-operations"
    Environment = local.resource_prefix.value
    yor_trace   = "95053fbf-ec0b-4213-bae0-12e368b7e7b1"
  }

}


resource "aws_s3_bucket" "operations_log_bucket" {
  bucket = "operations-log-bucket"
  tags = {
    yor_trace = "8f6cb4cc-64a4-4138-af98-d6887e8ce31c"
  }
}

resource "aws_s3_bucket_logging" "operations" {
  bucket = aws_s3_bucket.operations.id

  target_bucket = aws_s3_bucket.operations_log_bucket.id
  target_prefix = "log/"
}



resource "aws_s3_bucket_server_side_encryption_configuration" "operations" {
  bucket = aws_s3_bucket.operations.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket" "data_science" {
  # bucket is not encrypted
  bucket = "${local.resource_prefix.value}-data-science"
  region = "us-west-2"
  acl    = "private"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = "${aws_s3_bucket.logs.id}"
    target_prefix = "log/"
  }
  force_destroy = true
  tags = {
    yor_trace = "c25a9554-53db-402a-9e64-0fa5ab15f2d6"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "data_science" {
  bucket = aws_s3_bucket.data_science.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket" "logs" {
  bucket = "${local.resource_prefix.value}-logs"
  region = "us-west-2"
  acl    = "log-delivery-write"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "${aws_kms_key.logs_key.arn}"
      }
    }
  }
  force_destroy = true
  tags = {
    Name        = "${local.resource_prefix.value}-logs"
    Environment = local.resource_prefix.value
    yor_trace   = "4d60e877-7bf9-4b10-9a3e-c6034c310f9d"
  }
}


resource "aws_s3_bucket" "logs_log_bucket" {
  bucket = "logs-log-bucket"
  tags = {
    yor_trace = "d32e402e-a3c6-4052-bf6c-294b5e5f6bb8"
  }
}

resource "aws_s3_bucket_logging" "logs" {
  bucket = aws_s3_bucket.logs.id

  target_bucket = aws_s3_bucket.logs_log_bucket.id
  target_prefix = "log/"
}