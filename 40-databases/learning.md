# Issues faced while creating Databases
___
1. terraform_data.mysql (remote-exec): TASK [mysql : setup root password] *********************************************
terraform_data.mysql (remote-exec): fatal: [localhost]: FAILED! => {"msg": "An unhandled exception occurred while templating '{{ lookup('amazon.aws.aws_ssm', '/roboshop/{{ env }}/mysql_root_password', region='us-east-1', decrypt=True) }}'. Error was a <class 'ansible.errors.AnsibleLookupError'>, original message: Failed to find SSM parameter /roboshop/dev/mysql_root_password (ResourceNotFound)"}

terraform_data.mysql (remote-exec): PLAY RECAP *********************************************************************
terraform_data.mysql (remote-exec): localhost                  : ok=4    changed=3    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

terraform_data.mongodb: Still creating... [04m00s elapsed]
terraform_data.mongodb (remote-exec): changed: [localhost]

terraform_data.mongodb (remote-exec): TASK [mongodb : allow remote connections] **************************************
terraform_data.mongodb: Still creating... [04m10s elapsed]
terraform_data.mongodb (remote-exec): changed: [localhost]

terraform_data.mongodb (remote-exec): TASK [mongodb : start and enable mongodb] **************************************
terraform_data.mongodb (remote-exec): changed: [localhost]

terraform_data.mongodb (remote-exec): PLAY RECAP *********************************************************************
terraform_data.mongodb (remote-exec): localhost                  : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

terraform_data.mongodb: Creation complete after 4m16s [id=95cc6cf4-be58-1aed-8b83-d4eaaa44571a]
╷
│ Error: remote-exec provisioner error
│ 
│   with terraform_data.mysql,
│   on main.tf line 111, in resource "terraform_data" "mysql":
│  111:   provisioner "remote-exec" {
│ 
│ error executing "/tmp/terraform_531878344.sh": Process exited with status 2

ఇక్కడ problem చాలా clear గా ఉంది — **Terraform కాదు, Ansible + AWS SSM Parameter issue** 👍

---

## ❌ Root Error

```bash
Failed to find SSM parameter /roboshop/dev/mysql_root_password (ResourceNotFound)
```

👉 అంటే:

➡️ AWS SSM Parameter Store లో
👉 **`/roboshop/dev/mysql_root_password` అనే parameter లేదు**

---

## 🔥 Why this fails?

నీ Ansible task:

```jinja
lookup('amazon.aws.aws_ssm', '/roboshop/{{ env }}/mysql_root_password', ...)
```

👉 `env = dev` కాబట్టి ఇది try చేస్తుంది:

```bash
/roboshop/dev/mysql_root_password
```

👉 కానీ AWS లో అది create కాలేదు ❌

---

## ✅ FIX (Create SSM Parameter)

👉 ఈ command run చేయి (EC2 లో లేదా local machine లో):

```bash
aws ssm put-parameter \
  --name "/roboshop/dev/mysql_root_password" \
  --value "RoboShop@123" \
  --type "SecureString" \
  --region us-east-1
```

---

## 🔐 Important

* `SecureString` → encrypted storage
* `decrypt=True` → Ansible decrypt చేస్తుంది

---

## 🔍 Verify parameter exists

```bash
aws ssm get-parameter \
  --name "/roboshop/dev/mysql_root_password" \
  --with-decryption \
  --region us-east-1
```

---

## 🔁 Then retry Terraform

```bash
terraform apply
```

---

## ⚠️ Also check IAM permissions

👉 EC2 instance role లో ఈ permissions ఉండాలి:

```json
ssm:GetParameter
ssm:GetParameters
kms:Decrypt
```

---

## 🧠 DevOps Insight

👉 Roboshop infra లో common pattern:

| Component | SSM Parameter                       |
| --------- | ----------------------------------- |
| MySQL     | `/roboshop/dev/mysql_root_password` |
| Redis     | `/roboshop/dev/redis_password`      |
| RabbitMQ  | `/roboshop/dev/rabbitmq_password`   |

---

## 🏁 Final Summary

| Issue                      | Fix              |
| -------------------------- | ---------------- |
| SSM parameter not found    | create parameter |
| terraform remote-exec fail | rerun after fix  |
| ansible lookup error       | resolved         |

---

## 🚀 Next Step

👉 MySQL fix అయ్యాక:

* DB schema load
* app connectivity
* remaining services (redis, rabbitmq)

---

👉 ఇప్పుడు parameter create చేసి `terraform apply` run చేయి
👉 ఇంకా error వస్తే paste చెయ్యి — full debug చేస్తాను 👍

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ssm:GetParameter",
            "Resource": "arn:aws:ssm:us-east-1:160885265516:parameter/roboshop/${environment}/mysql_root_password"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "ssm:DescribeParameters",
            "Resource": "*"
        }
    ]
}

Edhi MySQL passowrd store chese file ye kadha? Telugu lo - **తెలుగులో సింపుల్ ఎక్స్ప్లనేషన్**

లేదు ❌ — ఇది **password store చేసే file కాదు**

👉 ఇది **IAM Policy (permissions file)** మాత్రమే.

---

## 🔍 Simple Telugu Explanation

ఈ JSON file అంటే:

👉 **EC2 / IAM Role కి permission ఇవ్వడం కోసం**

👉 అంటే:

> “ఈ system కి SSM లో ఉన్న password చదివే permission ఇవ్వు”

---

## 🔥 Breakdown

### 🔹 ఈ line చూడు:

```json
"Action": "ssm:GetParameter"
```

👉 అర్థం:
➡️ SSM Parameter Store నుండి value **read (get)** చేయవచ్చు

---

### 🔹 ఈ line:

```json
"Resource": "arn:aws:ssm:us-east-1:160885265516:parameter/roboshop/${environment}/mysql_root_password"
```

👉 ఇది చెబుతోంది:
➡️ `/roboshop/dev/mysql_root_password` వంటి parameter ని access చేయవచ్చు

---

## ⚠️ Important Point

👉 ఈ file లో:

❌ password లేదు
❌ value store కాదు

👉 ఇది కేవలం:

✔ ఎవరు access చేయగలరు
✔ ఏ parameter access చేయగలరు

అనే rules మాత్రమే

---

## ✅ Actual Password ఎక్కడ ఉంటుంది?

👉 AWS లో:

📍 **SSM Parameter Store**

అక్కడ:

```bash
/roboshop/dev/mysql_root_password
```

👉 ఇందులో actual value ఉంటుంది:

```bash
RoboShop@123
```

---

## 🔥 Real Flow (Understand this clearly)

1. 👤 Terraform / Ansible run అవుతుంది
2. 🔐 IAM Role → permission check చేస్తుంది
3. ☁️ SSM Parameter Store నుండి password fetch చేస్తుంది
4. 🛢️ MySQL setup కి use చేస్తుంది

---

## 🧠 Easy Analogy

| Thing          | Meaning                     |
| -------------- | --------------------------- |
| IAM Policy     | 🔑 Key (permission)         |
| SSM Parameter  | 🔐 Locker (actual password) |
| Password value | 💰 Locker లో ఉన్న డబ్బు     |

---

## 🏁 Final Answer

👉 ఈ file:
✔ Password store కాదు
✔ Permission define చేస్తుంది

👉 Password actual గా:
✔ AWS SSM Parameter Store లో ఉంటుంది

---

## 🚀 Next Step (Your case)

👉 నీ error fix అవ్వాలంటే:

```bash
aws ssm put-parameter \
  --name "/roboshop/dev/mysql_root_password" \
  --value "RoboShop@123" \
  --type "SecureString"
```
---

how to check password set or not in SQL server 

# solution
నువ్వు MySQL root password set చేశావ్ 👍
ఇప్పుడు **password set అయ్యిందా లేదా verify చేయాలి** — ఈ steps follow అవ్వు 👇

---

## ✅ Method 1: Login test (BEST & simple)

👉 ఇదే easiest way

```bash
mysql -u root -p
```

👉 తర్వాత password enter చేయి (నీ SSM లో ఇచ్చింది)

### ✔ If success:

```bash
Welcome to the MySQL monitor...
```

➡️ ✅ password correct & set అయింది

### ❌ If error:

```bash
Access denied for user 'root'@'localhost'
```

➡️ ❌ password wrong / set కాలేదు

---

## ✅ Method 2: Direct command test

```bash
mysql -u root -pYourPassword -e "SHOW DATABASES;"
```

👉 Example:

```bash
mysql -u root -pRoboShop@123 -e "SHOW DATABASES;"
```

✔ Output వస్తే → password working
❌ error వస్తే → issue ఉంది

---

## ✅ Method 3: Socket login check (debugging కోసం)

```bash
sudo mysql
```

👉 ఇది password లేకుండా login అవుతుంది (Linux auth)

Then:

```sql
SELECT user,host,plugin FROM mysql.user;
```

👉 output లో చూడాలి:

* `root` user
* plugin ideally `mysql_native_password` ఉండాలి

---

## ⚠️ Important Issue in your Ansible task

నీ task:

```yaml
mysql_secure_installation --set-root-pass "{{ MYSQL_ROOT_PASSWORD }}"
```

👉 ఇది **always reliable కాదు** ❌
👉 కొన్ని systems లో properly set చేయదు

---

## ✅ Recommended (Better way)

Instead use:

```yaml
- name: Set root password
  ansible.builtin.shell: |
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '{{ MYSQL_ROOT_PASSWORD }}';"
```

---

## 🔥 Extra Check

```bash
sudo systemctl status mysqld
```

👉 ensure:

```bash
active (running)
```

---

## 🧠 DevOps Tip

👉 Always verify after automation:

1. Service running ✅
2. Port open (3306) ✅
3. Login working ✅

---

## 🏁 Final Summary

| Check      | Command                                     |
| ---------- | ------------------------------------------- |
| Login test | `mysql -u root -p`                          |
| Quick test | `mysql -u root -pPASS -e "SHOW DATABASES;"` |
| Debug      | `sudo mysql`                                |

---

