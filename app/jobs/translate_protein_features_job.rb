class TranslateProteinFeaturesJob

  def perform
    features = Feature.where(feature_type: 'CDS')

    pbar = ProgressBar.new 'translating', features.count

    ActiveRecord::Base.transaction {
      Scaffold.cache {
        features.find_each do |feature|
          feature.update_nucleotide_sequence
          feature.update_protein_sequence
          feature.save!
          pbar.inc
        end
      }
    }

    pbar.finish
  end

end
