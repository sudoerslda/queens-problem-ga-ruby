require './chromosome.rb'
require './crossover.rb'

class Algorithm
  attr_reader :length, :population, :generations

  def initialize(length, population_count)
    @length = length
    # Make randomized population.
    @population = population_count.times.map { Chromosome::new_random length }
    # Reset generations counter.
    @generations = 0
  end

  def run(max_generations)
    @generations, best, cross_max_len = 0, @length / 2, 1
    max_generations.times.each do |g|
      @generations += 1
      # Sort by error, get best candidate.
      @population.sort! { |a, b| a.fitness <=> b.fitness }
      break if (best = @population.first).fitness == 0

      bests = []
      fitness = @population[0].fitness
      @population.each do |chromosome|
        break if bests.count >= 10 || fitness != chromosome.fitness
        bests << chromosome
      end

      # Make randomized population. Because the first element will be crossed-over
      # itself, it will be kept as the first chromosome, as a way for elitism to work.
      @population.map! do |chromosome|
        Crossover::do({
          mode:     :microbial,
          master:   bests.sample,
          slave:    chromosome,
          max_len:  cross_max_len,
        }).mutate({ chances: 2, times: 5 })
      end
    end
    best
  end
end
