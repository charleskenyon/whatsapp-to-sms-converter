all: init plan
# all: init plan apply

AWS_DEFAULT_REGION          ?= eu-west-2

TF_VAR_project            	?= whatsapp-to-sms-converter
TF_VAR_region                = $(AWS_DEFAULT_REGION)
TF_VAR_state_bucket         ?= $(TF_VAR_project)-state-bucket
TF_VAR_state_dynamodb_table ?= $(TF_VAR_project)-state-table

export

# check-var-%:
# 	@ if [ "${${*}}" = "" ]; then echo "Environment variable $* not set"; exit 1; fi

# init: check-var-env check-var-layer
init:
	cd infrastructure && rm -rf .terraform/
	cd infrastructure && terraform init -backend=true \
		-backend-config="bucket=$(TF_VAR_state_bucket)" \
		-backend-config="dynamodb_table=$(TF_VAR_state_dynamodb_table)" \
		-backend-config="key=default/terraform.tfstate" \
		-backend-config="region=$(TF_VAR_region)" \
		-backend-config="encrypt=true"

validate: 
	cd infrastructure && terraform validate

plan: 
	cd infrastructure && terraform plan \
		-out /tmp/plan;

apply: 
	cd infrastructure && terraform apply 

destroy: 
	cd infrastructure && terraform destroy
