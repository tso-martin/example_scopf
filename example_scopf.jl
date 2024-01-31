using JuMP
using Ipopt

# To use the HSL solvers, you need to install JuliaHSL from https://www.hsl.rl.ac.uk/
# add the HSL_jll package by running the following command in the REPL
# ] dev path_to_hsl_jll
# You can also use Ipopt with the default linear solver MUMPS by commenting out HSL_jll
import HSL_jll

_NLP_SOLVER = optimizer_with_attributes(
    Ipopt.Optimizer, 
    "print_level" => 5, 
    "tol" => 1e-2, 
    "acceptable_iter" => 5,
    "acceptable_tol" => 1e-1,
    "constr_viol_tol" => 1e-2,
    "compl_inf_tol" => 1e-3,
    "max_iter" => 700,
    "print_user_options" => "yes", 
    "print_timing_statistics" => "yes",
    "warm_start_init_point" => "yes")

# Uncomment if you want to use the default MUMPS linear solver 
set_attributes(_NLP_SOLVER, 
    "hsllib" => HSL_jll.libhsl_path,
    "linear_solver" => "ma57")

model = read_from_file("pm_graph.mof.json")
set_optimizer(model, _NLP_SOLVER)
# This takes about 188 iterations
optimize!(model)