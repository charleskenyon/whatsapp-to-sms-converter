all: init validate plan

-include .env

layer							?= whatsapp-converter-service

AWS_REGION						?= eu-west-2

TF_VAR_project            		?= whatsapp-to-sms-converter
TF_VAR_region					= $(AWS_REGION)
TF_VAR_state_bucket        		?= $(TF_VAR_project)-state-bucket
TF_VAR_state_dynamodb_table		?= $(TF_VAR_project)-state-table
TF_VAR_receiving_phone_number 	?= ${RECEIVING_PHONE_NUMBER}
TF_VAR_twilio_auth_token 		?= ${TWILIO_AUTH_TOKEN}
TF_VAR_twilio_account_sid 		?= ${TWILIO_ACCOUNT_SID}
TF_VAR_twilio_number 			?= ${TWILIO_NUMBER}
TF_VAR_twilio_number_sid 		?= ${TWILIO_NUMBER_SID}

export

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
	cd infrastructure/layers/$(layer) && terraform fmt -check
