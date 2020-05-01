# desc "Explaining what the task does"
# task :magic_link do
#   # Task goes here
# end

namespace :magic_link do 
  desc "Converts single magic links to new multi link table"
  task :move_to_multi => :environment do
    Magic::Link::Utility.move_to_multi 
  end
end 