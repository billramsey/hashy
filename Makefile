.PHONY: venv install start compose isort black format plan apply destroy kubectl-login build-push deploy

# Variables
VENV = .venv
PYTHON=$(VENV)/bin/python3
PROJECT_NAME=hashy
ECR_URL=072853783183.dkr.ecr.us-east-1.amazonaws.com

# Commands
venv:
	python3 -m venv $(VENV)

install:
	$(VENV)/bin/pip install -r requirements.txt

start:
	$(PYTHON) -m fastapi dev app/main.py

compose:
	docker-compose up --build

isort:
	$(PYTHON) -m isort --check-only app

black:
	$(PYTHON) -m black --check app

format:
	$(PYTHON) -m black app
	$(PYTHON) -m isort app
	terraform fmt -recursive terraform/

plan:
	cd terraform;terraform plan

apply:
	cd terraform;terraform apply

destroy:
	cd terraform;terraform destroy

kubectl-login:
	aws eks --region us-east-1 update-kubeconfig --name $(PROJECT_NAME) --alias $(PROJECT_NAME)
	kubectl config use-context $(PROJECT_NAME)

build-push:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(ECR_URL)
	docker build . --platform linux/amd64 -t $(PROJECT_NAME) --no-cache
	docker tag $(PROJECT_NAME) $(ECR_URL)/$(PROJECT_NAME):latest
	docker push $(ECR_URL)/$(PROJECT_NAME):latest

deploy:
	kubectl apply -f manifests/hashy-app.yml