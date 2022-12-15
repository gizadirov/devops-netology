# devops-netology

terraform/.gitignore
все ограничения будут применены к каталогу terraform

&ast;&ast;/.terraform/&ast; - все файлы из каталога '.terraform', который имеет любой уровень вложенности

*.tfstate - все файлы с расширением '.tfstate'

*.tfstate.&ast; - все файлы, содержащие в имени '.tfstate.'

crash.log - файл c именем 'crash.log'

crash.*.log - файлы с именем, начинающимся с 'crash.' и заканчивающимся '.log'

*.tfvars - файлы с расширением '.tfvars'

*.tfvars.json - файлы с именем, заканчивающимся '.tfvars.json'

override.tf, override.tf.json - файлы с именем 'override.tf' и 'override.tf.json'

*_override.tf - файлы с именем, заканивающимся на '_override.tf'

*_override.tf.json - файлы с именем, заканивающимся на '_override.tf.json'

.terraformrc - файлы с расширением '.terraformrc'

terraform.rc - файл с именем 'terraform.rc'