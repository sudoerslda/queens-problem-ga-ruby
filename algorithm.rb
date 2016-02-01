require './chromosome.rb'
require './crossover.rb'

class Algorithm
  attr_reader :iterations, :population

  def run(opts)
    opts = { num_threads: 5, length: 8, population: 500 }.merge opts
    # Assign variables.
    num_threads = opts[:num_threads]
    length = opts[:length]
    population_count = opts[:population]

    # Make randomized population.
    @population = population_count.times.map { Chromosome::new_random length }

    @iterations, half_length, bests = 0, (length / 2).floor, nil
    cross_max_len = opts.fetch :cross_max_len, length
    mut_times = opts.fetch :mut_times, half_length
    mut_chance = opts.fetch :mut_chance, 20
    opts.fetch(:iterations, 10000).times.each do |g|
      @iterations = g

      # Sort by error, get best candidate.
      @population.sort! { |a, b| a.fitness <=> b.fitness }
      break if @population[0].fitness == 0

      # Make randomized population. Because the first element will be crossed-over
      # itself, it will be kept as the first chromosome, as a way for elitism to work.
      bests, fitness = [], @population[0].fitness
      population_count.times.each do |i|
        break if (c = @population[i]).fitness > fitness
        bests << c
      end
      bests << @population.sample(5) if bests.count == 0

      if (g) % 50 == 0
        puts "Iteration #{g} ->"\
             " fitness = #{@population[0].fitness}, "\
             " elite count = #{bests.count}"
      end

      @population = num_threads.times.map { [] }
      (@population.map { |s|
        Thread.new(s) do |slice|
          (population_count / 4).floor.times.map do
            c = Crossover::perform({
              mode:     :microbial,
              master:   bests[0],
              slave:    Chromosome::new_random(length),
              max_len:  cross_max_len,
            })
            c.mutate mut_times, mut_chance
            c.fitness
            slice << c
          end
        end
      }).each { |t| t.join }
      @population.flatten!
    end
  end
end
