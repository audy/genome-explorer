DumpProteinsToFileJob = Struct.new(:filename) do

  def perform
    out = File.open(self.filename, 'w')

    tot = 0

    pbar = ProgressBar.new 'dumping', Feature.proteins.count

    # iterate over scaffolds rather than features because each feature's
    # scaffold needs to be looked up in order to retrieve its sequence. This
    # results in less calls to the DB.
    Scaffold.cache {
      Scaffold.find_each do |scaffold|
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
