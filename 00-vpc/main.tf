module "vpc" {
  # source = "git::<git-hub-project-link>"
  source = "git::https://github.com/SriRamCharanKolla/terraform-aws-vpc.git"
  # source = "../../terraform-aws-vpc"
  project = var.project
  environment = var.environment
  is_peering_required = true
}