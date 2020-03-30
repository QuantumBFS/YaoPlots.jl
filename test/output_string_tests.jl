# do_print_tests.jl
# Every test file should be a runnable script
using YaoPlots, Base.Test

# Test cases 
@test output_string(:MySymbol) == "MySymbol"
@test output_string(:x) == "x"
@test_throws MethodError output_string("MySymbol")


