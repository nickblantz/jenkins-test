# Steps for specs/configuration.feature

Given(/^the pipeline is "([^"]*)"$/) do |instruction|
  case instruction
  when "reading a configuration file"
	@xml_builder.add_script_content("""writeFile('jenkins-config.yml', ' ')
readConfig('jenkins-config.yml', 'DEV')	
""")
  else
    # fail
  end
end

Given("our repository has a valid configuration file") do
  puts "TODO: Populate test folder"
end

When("the pipeline is executed") do
  @xml_builder.export_xml("features/test_data/new.xml")
  @jenkins_api.create_job(@temp_job_name, "features/test_data/new.xml")
  # @jenkins_api.execute_job(@temp_job_name)
  # @jenkins_api.build_wait(@temp_job_name)
  @jenkins_api.execute_script("")
end

Then("the pipeline will succeed") do
  # @jenkins_api.build_output(@temp_job_name)
  # if @jenkins_api.build_result(@temp_job_name) != "SUCCESS"
    # abort("Test failed")
  # end
end
