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

  desc "summarize", "summarize breakfasts by month"
  def summarize
    months = Dir["static/*.jpg"].select {|path|
      File.basename(path, ".jpg").match(/^\d{4}-\d{2}-\d{2}$/)
    }.map {|path|
      File.basename(path)[0, 7]
    }.uniq
    months.each do |month|
      puts "Processing month: #{month}"
      paths = Dir["static/#{month}*.jpg"]
      alpha = 1.0 / paths.size
      paths.each_with_index do |path, i|
        puts " - #{path}"
        generate_transparent_image(path, "#{path}.transparent.png", alpha)
        if i == 0
          execute("cp '#{path}.transparent.png' #{month}_result.#{i}.png")
        else
          overray_images("#{path}.transparent.png", "#{month}_result.#{i-1}.png", "#{month}_result.#{i}.png")
        end
      end
    end
  end

  no_commands do
    def generate_transparent_image(source, target, alpha)
      execute("
        convert \
          '#{source}' \
          -alpha set \
          -background none \
          -channel A \
          -evaluate multiply #{alpha} \
          +channel \
          '#{target}'
      ")
    end

    def overray_images(source1, source2, target)
      execute("
        convert \
          '#{source1}' \
          '#{source2}' \
          -gravity center \
          -compose over \
          -composite \
          '#{target}'
      ")
    end

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

    def execute(command)
      puts "Executing: #{command}"
      system command
    end
  end
end
