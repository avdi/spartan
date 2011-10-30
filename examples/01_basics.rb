# # Spartans, prepare for glory!
#
# Spartan tests are ordinary Ruby code samples.

puts "Hello, world"             # => nil
1 + 1                           # => 2

# If you want, you can just run them as a plain ruby file.
#
#     ruby examples/01_basics.rb
#
# Running like this won't actually test anything, however, except that
# the code runs.

# Spartan files are annotated in xmp format. xmp annotations are
# special comments that follow lines of code. They consist of a pound
# symbol followed by a space and a hashrocket:

"natraps".reverse               # => "spartan"

# If you install the 'rcodetools' gem and run the "xmpfilter" program
# on the file, you'll see the special annotations are filled in with
# the result of the annotated line.

# In addition, xmpfilter also inserts any program output on STDOUT or
# STDERR at the end of the processed file.

warn "This is STDERR"
puts "This is STDOUT"

# (Look at the bottom of this section to see the output filled in.)

# Any text you put after the special xmp comments will be replaced by
# the actual values and output that the program generates.

# So if you write a line like this:
#
#     2 + 2 # => 5
#
# xmpfilter will replace the "5" with a "4".

2 + 2 # => 5

# It's this last property of xmpfilter which makes Spartan
# possible. When writing Spartan tests, you write xmp-annotated Ruby
# code. But instead of just adding xmp comments, you also fill in the
# values you _think_ will be generated by xmpfilter. Then you run
# `spartan`.

# Spartan runs the file through xmp filtering, filling in the actual
# outputs and values. Then it compares that output to the original
# file. If there are no differences, your predictions were correct,
# and the test passes. If the input and output differ, the test has
# failed. The failure report is simply the textual diff between your
# expected outputs and reality.

# Hey, remember when I said the output would be inserted at the end of
# the file? Well, here it is:

# >> Hello, world
# >> This is STDOUT
