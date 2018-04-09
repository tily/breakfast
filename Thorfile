require "time"
require "erb"

class Default < Thor
  TEMPLATE = <<~EOF
    +++
    date = "<%= date.iso8601 %>"
    title = "<%= date.strftime("%Y-%m-%d") %>"
    +++
    <img class="img-fluid" src="/<%= date.strftime("%Y-%m-%d") %>.jpg" />
  EOF

  desc "generate", "generate hugo files"
  def generate  
    puts "Generating markdown files"
    generate_markdown_files
    puts "Generating thumbnail_images"
    generate_thumbnail_images
  end

  no_commands do
    def generate_markdown_files
      Dir["static/*.jpg"].each do |path|
        next if path == "static/404.jpg"
        basename = File.basename(path, ".jpg") 
        date = Time.parse(basename)
        markdown = ERB.new(TEMPLATE).result(binding)
        markdown_path = "content/#{basename}.md"
        puts "Writing markdown content to #{markdown_path}"
        File.write(markdown_path, markdown)
      end
    end

    def generate_thumbnail_images
      Dir["static/*.jpg"].each do |path|
        basename = File.basename(path, ".jpg") 
        command = "convert -thumbnail 400x300 #{path} static/thumbs/#{basename}.jpg"
        puts "Executing: #{command}"
        system command
      end
    end
  end
end
