Before('@Jenkins') do
  @jenkins_api = JenkinsAPIInterface.new()
  @xml_builder = PipelineXMLBuilder.new("features/test_data/default.xml")
  @temp_job_name = "test-#{('a'..'z').to_a.shuffle[0,8].join}"
end

After('@Jenkins') do
  @jenkins_api.delete_job(@temp_job_name)
end