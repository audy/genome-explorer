require 'rails_helper'

NCBI_METADATA = {
  'taxid'                     => '438753',
  'isolate'                   => '',
  'asm_name'                  => 'ASM1052v1',
  'ftp_path'                  => 'ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/010/525/GCF_000010525.1_ASM1052v1',
  'biosample'                 => 'SAMD00060925',
  'submitter'                 => 'University of Tokyo',
  'bioproject'                => 'PRJNA224116',
  'genome_rep'                => 'Full',
  'wgs_master'                => '',
  'release_type'              => 'Major',
  'seq_rel_date'              => '2007/10/16',
  'organism_name'             => 'Azorhizobium caulinodans ORS 571',
  'species_taxid'             => '7',
  'assembly_level'            => 'Complete Genome',
  'version_status'            => 'latest',
  'gbrs_paired_asm'           => 'GCA_000010525.1',
  'paired_asm_comp'           => 'identical',
  'refseq_category'           => 'representative genome',
  'assembly_accession'        => 'GCF_000010525.1',
  'infraspecific_name'        => 'strain=ORS 571',
  'excluded_from_refseq'      => '',
  'relation_to_type_material' => 'assembly from type material'
}


describe BuildGenomeFeaturesJob do
  let(:genome) { Genome.create! ncbi_metadata: NCBI_METADATA }
  let(:job) { BuildGenomeFeaturesJob.new(genome) }

  it '#genbank_url returns a valid HTTPS url' do
    expect(job.genbank_url).to match(/^https:\/\//)
  end

  it 'can be performed' do
    expect { job.perform }.to_not raise_error
  end
end
