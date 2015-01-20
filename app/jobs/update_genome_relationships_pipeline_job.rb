#
# This job is meant to add *new* genomes and their features to the genomes and
# features similarity tables, respectively.
#
# This job starts by finding all genomes that have yet to be added to the graph
# (Genome.in_graph? == false), adding their proteins to the local proteins
# database and running USEARCH with their proteins against the entire proteins
# database, then creating new protein and genome relationships entries.
#
# 1. Find all genomes not in graph
# 2. Dump proteins to `new-proteins.fasta`
# 3. Concatenate `new-proteins.fasta` with `proteins.fasta`
# 4. Run usearch -query new-proteins.fasta -database proteins.fasta
# 5. Parse usearch output, adding new feature relationships
# 6. Add new genome relationships based on *only new* feature relationships
#   - How do I query for only new feature relationships? (probably just store
#     them after creation)

class UpdateGenomeRelationshipsPipelineJob

  def perform

    # must be an array! not a relation because relation will get updated
    # whenever Genome table changes.
    @new_genomes = Genome.where(in_graph: false).to_a

    if @new_genomes.count == 0
      puts "no new genomes, exiting!"
      return
    end

    ActiveRecord::Base.transaction {

      # dont update @new_genomes
      Genome.where(in_graph: false).update_all(in_graph: true)

      puts "updating graph w/ #{@new_genomes.count} genomes"

      # dump only new proteins beforehand. Assume that proteins.fasta is up to
      # date.
      # XXX maybe in the future check that proteins.fasta is up to date by
      # looking at the IDs or the last time it was updated ??
      DumpProteinsToFileJob.new('new-proteins.fasta',
                                @new_genomes.map(&:id)).perform

      # concatenate new-proteins.fasta with proteins.fasta because we want to
      # form intra-genome feature relationships.
      # todo: this needs to be tempfiles
      # todo: this needs to not default to proteins.fasta but some other file
      # so that tests and what-not don't step on it.
      `cat new-proteins.fasta >> proteins.fasta`

      # ** existing protein relationships are skipped
      imported_features = FindRelatedProteinsJob.new(input: 'proteins.fasta',
                                   database: 'proteins.fasta',
                                   skip_existing: true).perform

      # todo: only create *new* genome relationships using new protein
      # relationships
      # this is kind of a flawed method. Here I am just passing a list of
      # features to consider. I really should be passing a list of
      # relationships. This relies on the assumption that if a genome has
      # previously been added to the graph, it wouldn't have any new features
      FindRelatedGenomesJob.new.perform(imported_features)
    }
  end

  def max_run_time
    60 * 60 * 12 # 12 hours in seconds
  end

  def queue_name
    'big'
  end
end
