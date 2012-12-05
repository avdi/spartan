require 'rainbow'
module Spartan

  def verify_file(file_path, options = {})
    require 'English'
    require 'rcodetools/xmpfilter'
    require 'rcodetools/options'
    include Rcodetools
    example_file = file_path
    example_code = File.read(example_file)

    xmp_options = options.fetch(:xmp_options){{}}
    colorize = options[:colorize]

    output = ::XMPFilter.run(example_code,xmp_options)
    diff   = IO.popen("diff -u #{example_file} -", "r+")
    diff.write(output)
    diff.close_write
    results = diff.read
    diff.close_read
    if $CHILD_STATUS.success?
      message = "Green!"

      if colorize
        message = message.color(:green)
      end

      puts message

      exit 0
    else
      puts results
      exit 1
    end
  end

end
