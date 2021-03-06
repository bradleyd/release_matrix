require 'docker'

class ReleaseMatrix
	def initialize(opts)
		@dockerfiles_directory = opts[:dockerfiles_directory]
		@application_directory = opts[:application_directory]
		@destination_directory = opts[:destination_directory]
		@debug                 = opts[:debug] || false
		@release               = opts[:release]
		@docker_url            = opts[:docker_url] || "unix:///var/run/docker.sock"
		Docker.url             = @docker_url 
	end

	def run
		debug_params
		threads = []
		dockerfiles.each do |dfile|
			puts "Working on #{dfile}..."
			threads << Thread.new {
				begin 
					start = Time.now.to_i
					name  = File.basename(dfile)
					os    = name.split(".").last
					image = build_image(name)
					container   = build_container(os, image.id)
					file_handle = destination_file(os)
					container.copy(@release) { |chk| file_handle.write(chk) }
					file_handle.close
					container.delete(:force => true)
					image.remove(:force => true)
				  end_time = Time.now.to_i - start
					put_to_stdout("#{dfile} took #{end_time} seconds to complete")
				rescue => e
					puts "Error while building image and container: #{e.message}"
				end
			}
		end
		threads.map(&:join)
	end

	def dockerfiles
		Dir["#{@dockerfiles_directory}/*"]
	end

	def build_image(name)
		image = Docker::Image.build_from_dir(@application_directory, { 'dockerfile' => "dockerfiles/#{name}" })
		put_to_stdout("Image: #{image.id}")
		image
	end

	def build_container(os, image_id)
    container = Docker::Container.create('name' => "wameku-client-#{os}", 'Image' => image_id)
		put_to_stdout("Container: #{container.id}")
		container
	end

	def destination_file(os)
	  File.new("#{@destination_directory}/wameku-client-#{os}.tar", "wb")
	end

	private
	def debug_params
		put_to_stdout("Dockerfiles directory = #{@dockerfiles_directory}")
		put_to_stdout("Application directory = #{@application_directory}")
		put_to_stdout("Destination directory = #{@destination_directory}")
	end

	def put_to_stdout(message)
		$stdout.puts(message) if @debug
	end
end
