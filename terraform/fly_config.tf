resource "local_file" "fly_config" {
  filename = "${path.module}/../fly/fly.toml"
  content = templatefile("${path.module}/files/fly.toml.tftpl", {
    image_url        = local.container_image_url
    image_version    = local.container_image_version
    app_name         = local.fly_app_name
    r2_bucket_region = local.r2_bucket_region
  })
}
