require './algorithm.rb'
require './solution_checker.rb'

# We want 12 queens with a population of 3000 chromosomes.
# Run the algo, get the best result.
length = 8
half_length = (length / 2).floor
(algo = Algorithm.new).run({
  num_threads:    3,
  length:         length,
  population:     5000,
  iterations:     10000,
  cross_max_len:  length - 1,
  mut_times:      half_length - 5,
  mut_chance:     25
})
best = algo.population[0]

puts "Found solution #{best.genes.inspect} "\
     "after #{algo.iterations} generation(s) "\
     "with #{best.fitness} error(s)."

# Display solution results.
SolutionChecker.run best
