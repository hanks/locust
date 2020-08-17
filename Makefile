PWD := $(shell pwd)

coverage:
	coverage run -m unittest discover

test:
	tox

build:
	rm -f dist/* && python3 setup.py sdist bdist_wheel

release: build
	twine upload dist/*

build_docs:
	sphinx-build -b html docs/ docs/_build/

changelog:
	python3 generate_changelog.py

docker:
	docker build -t locust:1.0.0 .

run: docker
	docker rm -f locust-dev 2>/dev/null || true
	docker run --name locust-dev -v $(PWD):/home/locust --rm -p 8089:8089 locust:1.0.0
