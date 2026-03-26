locals {
    ami_id =  data.aws_ami.joindevops.id
    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
    # public subnet in 1a AZ
    database_subnet_id = split(",", data.aws_ssm_parameter.database_subnet_ids.value)[0]
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
    redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value
    mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
    rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id.value
    mysql_role_name = join("-", [
            for name in ["${var.project}","${var.environment}", "mysql"] : title(name) # title function is used to convert the first letter of each word to uppercase and rest to lowercase, join function is used to concatenate the list of strings with a separator which is - in this case
        ])
    mysql_policy_name = join("", [
            for name in ["${var.project}","${var.environment}", "mysql"] : title(name)
        ])

}