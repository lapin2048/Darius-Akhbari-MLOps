prepare:
	@echo "Initialisation des dépendances avec pyenv et poetry...";\
	pyenv install 3.10.9;\
	pyenv local 3.10.9;\
	poetry install

run:
	poetry run streamlit run app.py

check:
	poetry run vulture .
	poetry run isort .
	poetry run black .
	poetry run mypy .

build:
	docker build -t mlops .

push:
	docker login docker.io
	docker build -t docker.io/lapinou1/mlops:1 .
	docker push docker.io/lapinou1/mlops:1

deploy:
	kubectl apply -f streamlit-deployment.yaml
