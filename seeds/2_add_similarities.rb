require 'json'

namespace :seed do

  task :similarities do

    @neighbors = App::DB[:similarities]

    App::DB.transaction {

      # delete current relations!
      @neighbors.delete

      File.open('neighbors-0.txt') do |handle|

        pbar = ProgressBar.new 'loading', File.size(handle.path)

        handle.each do |line|
          pbar.set handle.pos
          dat = JSON.parse(line)
          query = dat["query"]
          dat["hits"].each do |hit|
            
            @neighbors.insert(source_id: query, target_id: hit)
          end
        end

        pbar.finish
      end

    } # transaction


  end

end
