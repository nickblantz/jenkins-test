# Sends and receives information from a Jenkins instance via API calls

class JenkinsAPIInterface

  def initialize()
    @base_uri = 'http://localhost:8080'
	@username = 'user'
	@token = '118342391ae6c660600b3216919c12e11e'
  end
  
  def create_job(job_name, config_file)
    puts("Creating job: #{job_name}")
    
    # API call
    uri = URI.parse("#{@base_uri}/createItem?name=#{job_name}")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@username, @token)
    request.content_type = "text/xml"
    request.body = File.read(config_file)
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
	
	# Error checking
	if response.code == 401
	  abort("Automation error | Jenkins account could not be authenticated")
	elsif response.code == 500
	  abort("Automation error | Jenkins could not create job")
	end
  end
  
  def execute_script(script_file)
    # API call
    uri = URI.parse("#{@base_uri}/scriptText")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@username, @token)
    request.content_type = "text/xml"
    # request.body = File.read(script_file)
	request.body = "script=println(Jenkins.instance.pluginManager.plugins)"
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
	puts "body" + response.body
	
	# Error checking
	if response.code == 401
	  abort("Automation error | Jenkins account could not be authenticated")
	elsif response.code == 500
	  abort("Automation error | Jenkins could not create job")
	end
  end
  
  def execute_job(job_name)
    puts("Executing job: #{job_name}")
    # API call
    uri = URI.parse("#{@base_uri}/job/#{job_name}/build")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@username, @token)
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
	
	# Error checking
	if response.code == 404
	  abort("Automation error | Job does not exist")
	end
  end
  
  def delete_job(job_name)
    puts("Deleting job: #{job_name}")
    
    # API call
    uri = URI.parse("#{@base_uri}/job/#{job_name}/doDelete")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@username, @token)
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
	
	# Error checking
  end
  
  def build_wait(job_name)
    print("Waiting for #{job_name} to finish")
	building = true
	
	until !building do
	  print(".")
	  
	  # API call
      uri = URI.parse("#{@base_uri}/job/#{job_name}/1/api/xml")
      request = Net::HTTP::Post.new(uri)
      request.basic_auth(@username, @token)
      req_options = { use_ssl: uri.scheme == "https" }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
	  
	  unless response.code == "404"
	    build_result = Nokogiri::XML(response.body)
	    building = build_result.xpath("//workflowRun//building").first.content == "true"
	  end
	  
	  sleep(5)
	end
	puts("Done")
  end
  
  def build_result(job_name)
    # API call
    uri = URI.parse("#{@base_uri}/job/#{job_name}/1/api/xml")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@username, @token)
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
	
	build_result = Nokogiri::XML(response.body)
	return build_result.xpath("//workflowRun//result").first.content
  end
  
  def build_output(job_name)
    # API call
    uri = URI.parse("#{@base_uri}/job/#{job_name}/1/consoleText")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@username, @token)
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
	
	File.open('output.txt', 'w') { |file| file.write(response.body) }
  end
end