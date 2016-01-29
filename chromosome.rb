class Chromosome
  attr_reader :length, :genes, :fitness

  def initialize(opts = {})
    @length = opts.fetch :length, 8
    @genes = opts.fetch :genes, []
    yield self if block_given?
  end

  def mutate(opts)
    mut = 0
    opts[:times].times.each do
      next unless rand(100) < opts[:chances]
      mut += 1
      idx1 = rand(@length)
      until (idx2 = rand(@length)) != idx1; end
      @genes[idx1], @genes[idx2] = @genes[idx2], @genes[idx1]
    end
    self
  end

  # Determines to what level this chromosome is fit to survive.
  # The higher the return value is, the less viable is the chromosome.
  def fitness
    @fitness ||= (
      outter_bound, inner_bound = @length -2, @length - 1
      (0..outter_bound).inject(0) do |e1, x1|
        y1 = @genes[x1]
        e1 + ((x1+1)..inner_bound).inject(0) do |e2, x2|
          y2 = @genes[x2]
          dx, dy = (x1 - x2).abs, (y1 - y2).abs
          e2 + ((y1 == y2 || dx == dy) ? 1 : 0)
        end
      end
    )
  end

  # Allow duplication of a chromosome for easing crossover. The fitness is not
  # duplicated (cache-busting).
  def dup
    self.class.new(
      length:   @length,
      genes:    @genes.dup
    )
  end

  # Creates a new Chromosome instance with random genes.
  def self.new_random(length, &block)
    new length: length, genes: (0..(length-1)).to_a.shuffle, &block
  end
end
