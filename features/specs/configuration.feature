@Jenkins @Configuration @QA @UAT
Feature: Reading pipeline configurations from a repository's jenkins-config.yml

  Background:
    Given the pipeline is "reading a configuration file"
	
  Scenario: We provide a valid configuration file
    Given our repository has a valid configuration file
     When the pipeline is executed
     Then the pipeline will succeed