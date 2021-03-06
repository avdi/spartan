require 'bundler'
require_relative '../spartan'

Bundler.setup
Bundler::GemHelper.install_tasks(name: "spartan")

namespace "spartan" do
  include Spartan

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
            elsif [:code, :output].include?(state) && line =~ /^\# /
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
      verify_file(file.to_s, xmp_options: { include_paths: [lib_path] })
    end
  end
end
