class SolutionChecker
  def self.run(chromosome)
    length, genes = chromosome.length, chromosome.genes
    puts "Checking solution..."
    # Prepare empty array.
    occupied = genes.map { Array.new length, false }

    err = 0
    bound = length - 1
    range = 0..bound
    genes.each_with_index do |y, x|
      err += 1 if occupied[x][y]
      # Mark whole line as occupied
      range.each do |i|
        if occupied[i][y]
          puts "  (#{x},#{y})[+row]: already occupied at (#{i},#{y})."
          err += 1
        end
        if occupied[x][i]
          puts "  (#{x},#{y})[+col]: already occupied at (#{i},#{y})."
          err += 1
        end
      end

      # Check top-right diagonal.
      ty = y; ((x + 1)..bound).each do |tx|
        break if (ty += 1) > bound
        if tx != x && ty != y && occupied[tx][ty]
          puts "  (#{x},#{y})[dtr]: already taken at (#{tx},#{ty})."
          err += 1
        end
      end
      # Check top-left diagonal.
      ty = y; (x - 1).downto(0).each do |tx|
        break if (ty += 1) > bound
        if tx != x && ty != y && occupied[tx][ty]
          puts "  (#{x},#{y})[dtl]: already taken at (#{tx},#{ty})."
          err += 1
        end
      end
      # Check bottom-right diagonal.
      ty = y; ((x + 1)..bound).each do |tx|
        break if (ty -= 1) < 0
        if tx != x && ty != y && occupied[tx][ty]
          puts "  (#{x},#{y})[dbr]: already taken at (#{tx},#{ty})."
          err += 1
        end
      end
      # Check bottom-left diagonal.
      ty = y; (x - 1).downto(0).each do |tx|
        break if (ty -= 1) < 0
        if tx != x && ty != y && occupied[tx][ty]
          puts "  (#{x},#{y})[dbl]: already taken at (#{tx},#{ty})."
          err += 1
        end
      end

      # Mark this position as occupied.
      occupied[x][y] = true
    end
    err
  end
end
