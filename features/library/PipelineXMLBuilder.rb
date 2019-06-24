# Generates a config.xml with a specified pipeline script for Jenkins

class PipelineXMLBuilder
  include Nokogiri
  
  def initialize(file_location)
    @pipeline_config_xml = Nokogiri::XML(File.read(file_location))
	@method_list = []
	@jenkinsfile_begin = """
@Library('pipeline-library-dev')_

pipeline {
	agent { node { label 'master' } }

	stages {
		stage ('Pipeline Testing') {
			steps {
				script {"""
    @jenkinsfile_end = """
				}
			}
		}
	}
}
"""
  end
  
  def add_script_content(method)
    @method_list << method
  end
  
  def export_xml(file_location)
    @pipeline_config_xml.xpath("//flow-definition//definition//script").first.content = generate_jenkinsfile().encode()
	File.write(file_location, @pipeline_config_xml.to_xml)
  end
  
  private
  
  def generate_jenkinsfile()
    output = @jenkinsfile_begin
	@method_list.each do |method|
	  output << "\n#{method}"
	end
	output << @jenkinsfile_end
	return output
  end
end