all: init validate plan

layer						?= whatsapp-converter-service

AWS_DEFAULT_REGION			?= eu-west-2

TF_VAR_project            	?= whatsapp-to-sms-converter
TF_VAR_region				= $(AWS_DEFAULT_REGION)
TF_VAR_state_bucket        	?= $(TF_VAR_project)-state-bucket
TF_VAR_state_dynamodb_table	?= $(TF_VAR_project)-state-table

include .env

export

# check-var-%:
# 	@ if [ "${${*}}" = "" ]; then echo "Environment variable $* not set"; exit 1; fi

# init: check-var-env check-var-layer
init:
	cd infrastructure/layers/$(layer) && rm -rf .terraform/
	cd infrastructure/layers/$(layer) && terraform init -backend=true \
		-backend-config="bucket=$(TF_VAR_state_bucket)" \
		-backend-config="dynamodb_table=$(TF_VAR_state_dynamodb_table)" \
		-backend-config="key=$(layer)/terraform.tfstate" \
		-backend-config="region=$(TF_VAR_region)" \
		-backend-config="encrypt=true"

validate: 
	cd infrastructure/layers/$(layer) && terraform validate

plan: 
	cd infrastructure/layers/$(layer) && terraform plan -input=false \
		-out /tmp/plan;

apply: 
	cd infrastructure/layers/$(layer) && terraform apply -auto-approve

destroy: 
	cd infrastructure/layers/$(layer) && terraform destroy

output: 
	cd infrastructure/layers/$(layer) && terraform output

format:
	cd infrastructure/layers/$(layer) && terraform fmt
