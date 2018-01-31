# CI pipeline

This is the pipeline to manage data science repos.


## Setup


```
CONCOURSE_URL=http://127.0.0.1:8080
fly -t ds login -c $CONCOURSE_URL

fly -t ds set-pipeline --pipeline datascience --config pipeline.yml
fly -t ds ds unpause-pipeline --pipeline datascience
```
