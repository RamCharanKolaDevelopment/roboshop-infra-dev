module "component" {
  for_each = var.components
  source = "git::https://github.com/SriRamCharanKolla/terraform-roboshop-component.git"
  component = each.key
  rule_priority = each.value.rule_priority
}