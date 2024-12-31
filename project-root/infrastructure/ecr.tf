resource "aws_ecr_repository" "ocr_django" {
  name                 = "ocr-django-service"
  image_tag_mutability = "MUTABLE"
  tags                 = var.tags
}

