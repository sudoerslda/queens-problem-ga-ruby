class Crossover
  # This method blends two genes based on a mode and on a maximum
  # length for permutations.
  def self.perform(opts)
    case opts.fetch(:mode, :microbial)
    when :microbial
      microbial_crossover opts
    end
  end

  def self.microbial_crossover(opts)
    master, slave = opts[:master], opts[:slave]
    slave = opts[:slave]
    offspring = slave.dup

    len = rand(opts[:max_len]) + 1
    cross_start = rand(slave.length - len)
    cross_end = cross_start + len
    len.times.each { offspring.genes[cross_end] = master.genes[cross_end] }
    offspring
  end
end
