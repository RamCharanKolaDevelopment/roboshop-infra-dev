module "sg" {
  count = length(var.sg_names)
  # source = "../../terraform-aws-sg"
  source = "git::https://github.com/SriRamCharanKolla/terraform-aws-sg.git"
  project = var.project
  environment = var.environment
  sg_name = replace(var.sg_names[count.index], "_", "-")
  vpc_id = local.vpc_id

}