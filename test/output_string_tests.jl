# do_print_tests.jl

# Optional: put using statements at the top.
# My personal preference is to have every test file be a runnable script
# This means that if someone was to run just this file, it should work
# This makes it easy to grab a part of your testset and dig into what the error is.
using ExamplePackage, Base.Test

# Write a few tests
@test output_string(:MySymbol) == "MySymbol"
@test output_string(:x) == "x"
@test_throws MethodError output_string("MySymbol")
