build:
	docker build -f ci/Dockerfile -t natbusa/titanic:latest .

run:
	docker run -v `pwd`/src:/home/jovyan/src \
	           -v `pwd`/data:/home/jovyan/data \
					 	 -v `pwd`/datalabframework:/home/jovyan/datalabframework \
	           -p 8888:8888 natbusa/titanic start.sh \
						 jupyter lab
