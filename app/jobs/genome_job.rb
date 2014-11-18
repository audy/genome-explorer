require 'json'

class GenomeJob < Struct.new :genome_id

  def perform
    @genome = Genome.find(genome_id)
    dat = query_ncbi(@genome.assembly_id)
    @genome.update organism: dat['organism']
  end

  def error job, exception
    puts "GenomeJob failed! job = #{job}, exception = #{exception}"
    record_stat 'genome_job/failed'
  end

  def success job
    record_stat 'genome_job/success'
  end

  private

  def query_ncbi(assembly_id)
    JSON.parse(`bionode-ncbi search assembly #{self.assembly_id}`)
  end

end
