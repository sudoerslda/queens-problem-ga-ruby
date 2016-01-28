require './algorithm.rb'
require './solution_checker.rb'

# We want 12 queens with a population of 3000 chromosomes.
algo = Algorithm.new 12, 2000
# Run the algo, get the best result.
best = algo.run 1000

puts "Found solution #{best.genes.inspect} "\
     "after #{algo.generations} generation(s) "\
     "with #{best.fitness} error(s)."

# Display solution results.
SolutionChecker.run best
