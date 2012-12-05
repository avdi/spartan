# Running spartan from the command line

executable = File.expand_path("../bin/spartan", __FILE__)
passing_example = File.expand_path("../example_examples/01_passing_example.rb", __FILE__)
failing_example = File.expand_path("../example_examples/02_failing_example.rb", __FILE__)

Process.spawn("#{executable} #{passing_example}")
Process.wait
$?.success? # => true

Process.spawn("#{executable} #{failing_example}")
Process.wait
$?.success? # => false