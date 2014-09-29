class BuildProteinsMatrix

  attr_reader :index

  AMINO_ACIDS = %w{A R N D C E Q G H I L K M F P S T W Y V}

  def initialize
    @shingle_size = 2
    @alphabet = AMINO_ACIDS.combination(@shingle_size).map(&:join)
    @storage = LSH::Storage::RedisBackend.new()
    @index = LSH::Index.new({
        dim: @alphabet.size, 
        number_of_random_vectors: 8, 
        window: Float::INFINITY, 
        number_of_independent_projections: 150
      }, @storage)
  end

  def perform
    Scaffold.find_each do |scaffold|
      scaffold.features.where(feature_type: 'CDS').each do |feature|
        p add_to_index(feature)
      end
    end

  end

  def find_similar_proteins(feature)
    vector = vectorize(feature)
    results = @index.query(vector)
    @index.order_results_by_similarity(vector, results)
#    compute_similarities(vector, results)
  end

  def compute_similarities(vector, results)
    vector_t = vector.transpose
    results.map do |result|
      result.update({ similarity: @index.similarity(result[:data], vector_t) })
    end
  end

  def add_to_index(feature)
    matrix_id = @index.add vectorize(feature)
    feature.update matrix_id: matrix_id
  end

  # convert a feature (protein) into a vector
  def vectorize(feature)
    shingles = shingles(feature.protein_sequence)
    features = generate_features(shingles)
    GSL::Matrix.alloc(features)
  end

  # generate feature vector from array of shingles
  def generate_features(shingles)
    h = Hash.new { |h, k| h[k] = 0 }
    shingles.map { |d| h[d] += 1 }
    @alphabet.map { |a| h[a] }
  end

  # convert string (amino acid sequence) to shingles
  def shingles(str)
    (0..(str.size - @shingle_size )).map do |i|
      str[i..i+@shingle_size-1]
    end
  end

end
