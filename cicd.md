## CI/CD:

### Repo

The CI/CD Pipeline for data science starts with a repo.   
The repo should contain at least the following structure

#### Directory structure

```
  - ci
  
  - binder
    environment.yml
  
  - data
    - raw
    - extract
    - clean
    - features
    - model
      - training
      - scoring
      
  - src
    __init__.py
    __main__.py
    metadata.yml
```

* `ci`   
contains the scripts to run the ci/cd pipeline (test, lint, analysis, package, publish, deploy). 
* `binder`  
contains the packages for the OS, Python, R, which are required to successfully run the script in the repositorie.
* `data`   
contains data to run the tests in a self-contained manner, without having to refer to external sources
* `src`  
contains the files (notebooks, code and scripts for your data science project) 
the file names and directory structure is mostly free format with the expection of `__main__.py` file and a `metadata.yaml` file. The `__main__.py` file can be empty and marks the beginning

#### Metadata

Metadata is read in a bread-first manner starting from to top src directory down to the various module directory marked by an `__init__.py` file,
according to the python module convention. Only files named `metadata.yml` will be read in.

The metadata information can be split across multiple files or condensed in asingle file at the top level. Multiple yaml document in a single file are permitted. Yaml configuration is namespaced using the `name` attribute at the toplevel.

Cascading configuration:  
When determining the value of a given configuration parameter the following process if applied:

 - metadata.defaults.yml 
 - metadata.yml (hierachically merged top-down bread-first search)
 - DLF_METADATA (environment variable)

Moreover for a given configuration namespace such as `prod`, `test`, `dev`, etc. the environment inherits all variables from the namespace `root` (no `name` attribute in the yaml metadata configuration implies `root` namespace). Here below and example of the configuration in a single file:

```
---
name: root
data:
    providers:
        - s3
        - local
        - elasticsearch
        - redis
        - ...
    resources:
        <resource-id-1>:
            path:
            format:
        <resource-id-2>:
            path:
            format:   
execution:
    engines: 
        - spark
        - pandas
        - flink
        - ...
logging:
    severity: info
    handlers:
        - stdio
        - kafka
        - ...
---
name: prod
data:
    default:
        provider: s3
execution:
    engines: 
        - spark
            master: spark-master.cluster1.example.com
---
name: test
data:
    default:
        provider: local
execution:
    engines: 
        - spark
            master: local[4]
---
```
Conventions:   

Metadata should be as much as possible independent from the spacific namespace such as `prod`, `test` etc. To avoid unnecessary data resources definition keep the same taxonomy / structure of the data objects across multiple providers. Do not hard-code file names, engines and data services in the notebooks or in the data science code.

### Git and Git Services and Collaboration

The repo is kept under a git webservice such as `github`, `gitlab`, `gitea`. The process of collaborating follows the clone / pull-request well documented process. The reference project will have a number of core committers. Best practice is the the pull-requester and the commiter on the reference project are not the same person, always enforcing at least a two people / two phases commit setup. Most checks should be automated as cicd tasks and not rely on human inspection/manual testing.

### Hooks

Commit hooks and pull-request hooks trigger the cicd pipeline(s). This are managed by non-personal users a.k.a bots. For instance Jenkins could be one of this agents. Upon completion of the hook command, the agent should report back a fail/success message to the git webservice with a remark about the results.

### CICD tasks

The following tasks should be performed:

* static analysis
    - build the Data Flow Graph (DFG)
    - lint on the code and notebooks
    - analyze the stats about code quality (markdown, code complexity, etc)
* testing
    - execute the scripts according to the DFG dependencies
    - collect stats about ML enginering: computing time, resources
    - collect stats about ML models: precision/recall, ROC curve,
* package
    - package the repo (such as python wheel, zip file, docker image, vm)
* publish 
    - publish the built artifact 
* deploy 
    - automate deploy by registering the artifact
    - differentiate between batch processing and runtime environments
    - batch is registered on a scheduler (concourse)
    - runtime is registered on a container pool service (kubernetes)

Most of the action should be generic for the framework and not rely on specific scripts. Configuration over Coding.
