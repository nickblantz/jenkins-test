# Jenkins Testing Pipeline - v0.1
A testing pipeline which executes behavioral-driven development tests written in [Gherkin](https://docs.cucumber.io/gherkin/) from a specified repository. This pipeline allows tests to be organized and tested in an environment-centric way which accomodates for multiple enviroments of of one type (i.e. QA1, QA2) as well for different stages of testing (i.e. Smoke, API, UI)

## Dependencies

### Plugin Requirements
* [Pipeline](https://wiki.jenkins.io/display/JENKINS/Pipeline+Plugin)
* [Pipeline Utility Steps](https://wiki.jenkins.io/display/JENKINS/Pipeline+Utility+Steps+Plugin)
* [Git](https://wiki.jenkins.io/display/JENKINS/Git+Plugin)

### Library Requirements
* [Jenkins Pipeline Library](https://github.com/QATInc/jenkins-library)

## Setup
1. Navigate to the new item page in Jenkins (http://JENKINS_URL/view/all/newJob)
2. Enter a name for the job
3. Select pipeline
4. Click 'OK'
5. Navigate to the 'Pipeline' section
5. Set the definition as 'Pipeline script from SCM'
6. Set the SCM as 'Git'
7. Set the repository URL as 'https://github.com/QATInc/jenkins-core'
8. Set the script path as 'pipeline.jenkinsfile'
9. Save your configuration
10. Click 'Build Now' and expect the build to fail

## Usage
Run the pipeline with a specified repository, branch, and environment. Please see [this example repository](https://github.com/QATInc/SMORES/) for reference

### jenkins-config.yml
For a repository to be tested, it must include a file named 'jenkins-config.yml' at its root directory containing the following:
* ```language``` - Project language
* ```ignore_tag``` - Tag that marks a scenario to be ignored
* ```environments``` - Map of testing environments
* ```env_type``` - Tag that associates a scenario with an environment
* ```stages``` - List of tags to be tested in an environment
* ```email``` - List of email recipients that are notified at the end of a build

Example:
```
language: ruby
ignore_tag: ToDo
environments:
  DEV1:
    env_type: DEV
    stages:
      - Smoke
      - API
  DEV2:
    env_type: DEV
    stages:
      - Smoke
      - API
  QA1:
    env_type: QA
    stages:
      - Smoke
      - API
      - UI
email:
  - example@example.com
```

### Test Execution
When the pipeline is run, it looks for all online agents matching the jenkins-config.yml's language value. It first clones the repository to these agents and prepares the environments to run the tests. Next, it executes a dry-run to determine all features present in the repository. Then, the pipeline splits the tests by feature, dynamically sending each feature's tests to agents for execution. 

For each stage in the specified environments, cucumber will run scenarios matching the tagging logic:
```
@env_type and @stage and not @Invalid
```

