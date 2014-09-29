
desc 'cluster proteins based on similarity'
task :cluster_proteins => [:environment] do
  # first build the protein matrix
  puts 'clustering proteins wooh!'

  mat = BuildProteinsMatrix.new

  Feature.where(feature_type: 'CDS').first(100).each do |feature|

    mat.find_similar_proteins(feature).last(10).each do |feat|
      similar_protein = Feature.where(matrix_id: feat[:id]).limit(1)
      feature.related_features << similar_protein
      feature.save
      p feature
    end

  end
end

task :build_matrix => :environment do
  puts 'building matrix woohoo!'
  matrix_builder = BuildProteinsMatrix.new
  matrix_builder.perform
end
