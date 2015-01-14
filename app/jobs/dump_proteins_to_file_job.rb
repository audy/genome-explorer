DumpProteinsToFileJob = Struct.new(:filename) do

  def perform
    out = File.open(self.filename, 'w')

    tot = 0

    pbar = ProgressBar.new 'dumping', Feature.where(feature_type: 'CDS').count

    Scaffold.cache {
      Feature.proteins.find_each do |feature|
        pbar.inc
        # skip proteins w/ weird starts or stops in the middle or dont end in a
        # stop.
        out.puts ">#{feature.id}\n#{feature.protein_sequence}" unless feature.weird?
        tot += 1
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
