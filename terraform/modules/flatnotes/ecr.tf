resource "aws_ecr_repository" "flatnotes" {
  name                 = "flatnotes"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false # Enable image scanning on push
  }

  encryption_configuration {
    encryption_type = "AES256" # Default encryption type. Use "KMS" for KMS encryption.
  }

  tags = {
    Name        = "flatnotes"
    Environment = "test"
  }
}

resource "aws_ecr_repository_policy" "flatnotes" {
  repository = aws_ecr_repository.flatnotes.name

  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "AllowPublicAccessForECRGetDownloadUrlForLayer"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "ecr:GetDownloadUrlForLayer"
        ]
      }
    ]
  })
}
