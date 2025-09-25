.PHONY: dev test lint type cov

dev:
	uvicorn src.app:create_app --factory --reload

test:
	pytest -q

lint:
	ruff check . && black --check .

type:
	mypy --strict

cov:
	pytest -q --cov=src --cov-report=xml:coverage/coverage.xml --cov-report=html:coverage/html

