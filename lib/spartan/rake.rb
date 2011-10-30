require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks(name: "spartan")

namespace "spartan" do
  def project_root
    Dir.pwd
  end
  
  def examples_dir(project_root)
    Pathname(project_root) + 'examples'
  end

  def example_files(project_root)
    Pathname.glob(examples_dir(project_root) + "*.rb")
  end

  def lib_path
    Pathname(project_root) + "lib"
  end

  def verify_file(file_path)
    require 'English'
    require 'rcodetools/xmpfilter'
    require 'rcodetools/options'
    include Rcodetools
    example_file = file_path
    example_code = File.read(example_file)
    xmp_options = {
      include_paths: [lib_path]
    }
    output = ::XMPFilter.run(example_code,xmp_options)
    diff   = IO.popen("diff -u #{example_file} -", "r+")
    diff.write(output)
    diff.close_write
    results = diff.read
    diff.close_read
    if $CHILD_STATUS.success?
      puts "Green!"
      exit 0
    else
      puts results
      exit 1
    end
  end

  task "load_path" do
    $LOAD_PATH.unshift(File.expand_path("lib", Dir.pwd))
  end

  desc "Generate documentation from examples"
  task "doc" do
    open(Pathname(project_root) + "README.markdown", 'w') do |readme|
      example_files(project_root).each do |example_path|
        open(example_path, 'r') do |example|
          state = :comment
          while line = example.gets
            if [:comment,:blank].include?(state) && line =~ /^\s*$/
              state = :blank
            elsif [:comment,:blank].include?(state) && line =~ /^\s*[^\s#]/
              state = :code
              readme.puts "\n```ruby"
            elsif [:blank, :comment, :code].include?(state) && line =~ /^\# >>/
              state = :output
              readme.puts "\n```"
            elsif state == :blank && line =~ /^\# /
              readme.puts
              state = :comment
            elsif [:code, :output].include?(state) && line =~ /^ \# /
              state = :comment
              readme.puts "```"
            end
            readme.puts line.sub(/^#\s*/, "") unless state == :blank
          end
          if state == :output
            readme.puts "```"
          end
        end
      end
    end
  end

  desc "Run the tests"
  task "test" => %w[load_path] do
    example_files(Dir.pwd).each do |file|
      verify_file(file.to_s)
    end
  end
end
