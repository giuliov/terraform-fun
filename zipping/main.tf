data "archive_file" "DSC" {
  type        = "zip"
  output_path = "${path.module}/DSC.zip"

  source_dir = "${path.module}/DSC/"
}
