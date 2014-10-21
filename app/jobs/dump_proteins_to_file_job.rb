DumpProteinsToFileJob = Struct.new(:filename) do

  def perform
    out = File.open(self.filename, 'w')

    tot = 0

    Scaffold.find_each do |scaffold|
      scaffold.features.where(feature_type: 'CDS').each do |feature|
        seq = feature.protein_sequence
        # skip proteins w/ weird starts or stops in the middle or dont end in a
        # stop.
        out.puts ">#{feature.id}\n#{feature.protein_sequence}" unless feature.weird?
        tot += 1
      end
    end

    out.close

    return tot
  end

end
