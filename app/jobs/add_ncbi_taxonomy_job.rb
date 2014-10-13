require 'csv'

class AddNCBITaxonomyJob

  def perform
    # download names.dmp and nodes.dmp from NCBI's FTP server
    # download_taxonomies_from_ncbi
    # build tree in memory
    # import into database

    names = Hash.new
    nodes = []

    puts 'loading names'
    read_names('scientific_names.dmp').each_with_index do |name, i|
      names[name[0]] = name[1]
    end

    puts "loaded #{names.size} names"

    puts 'loading nodes'
    read_nodes('nodes.dmp').each_with_index do |node, i|
      # build node array (see columns)
      node << names[node[0]]
      nodes << node
    end

    puts "loaded #{nodes.size} nodes"

    columns = [ :id, :parent_id, :rank, :name ]

    p nodes[0..10]

    puts 'importing nodes w/ names'
    Taxonomy.transaction {
      Taxonomy.destroy_all
      Taxonomy.import columns, nodes, validate: false
    }
    
  end

  def download_taxonomies_from_ncbi
    system 'wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz'
    system 'tar -zxvf taxdump.tar.gz'
    # pre-filter names to keep *only* scientific names. names.dmp is really huge
    # causing a lot of lines to be iterated over for nothing.
    system 'grep "scientific name" names.dmp > scientific_names.dmp'
  end

  def read_nodes nodes_file
    Enumerator.new do |enum|
      CSV.foreach(nodes_file, col_sep: "\t") do |row|
        child = Integer(row[0])
        parent = Integer(row[2])
        level = row[4]
        enum.yield [ child, parent, level ]
      end
    end
  end

  def read_names names_file
    Enumerator.new do |enum|
      # csv chokes on malformatted quotes, we don't want to split on quotes
      # so set the quote char to something that should never be encountered
      CSV.foreach(names_file, col_sep: "\t", quote_char: "\x00") do |row|
        next unless row[6] == 'scientific name'
        id = Integer(row[0])
        name = row[2]
        enum.yield [ id, name ]
      end
    end
  end
end
