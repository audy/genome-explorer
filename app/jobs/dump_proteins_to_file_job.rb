DumpProteinsToFileJob = Struct.new(:filename, :genomes) do

  def perform
    out = File.open(self.filename, 'w')

    tot = 0

    pbar = ProgressBar.new 'dumping', Feature.proteins.count

    # dump features from all genomes.
    @scaffolds =
      if self.genomes.nil?
        Scaffold.all
      else # dump only genomes in specific array
        Scaffold.where(genome_id: self.genomes)
      end

    puts "dumping proteins for #{@scaffolds.count} scaffolds"

    # iterate over scaffolds rather than features because each feature's
    # scaffold needs to be looked up in order to retrieve its sequence. This
    # results in less calls to the DB.
    Scaffold.cache {
      @scaffolds.find_each do |scaffold|
        scaffold.features.proteins.find_each do |feature|
          pbar.inc
          out.puts ">#{feature.id}\n#{feature.protein_sequence}" unless feature.weird?
          tot += 1
        end
      end
    }

    pbar.finish

    fail 'no proteins' unless tot > 0

    puts "wrote #{tot} proteins"

    out.close

    return tot
  end

  def queue
    'big'
  end

end
