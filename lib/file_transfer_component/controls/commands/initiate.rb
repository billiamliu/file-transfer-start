module FileTransferComponent
  module Controls
    module Commands
      module Initiate
        def self.example

          initiate = FileTransferComponent::Messages::Commands::Initiate.build

          initiate.file_id = ID.example
          initiate.name = "some_name"
          initiate.temp_path = "some_temp_path"
          initiate.time = Controls::Time.example

          initiate
        end

        def self.data
          data = example.attributes
          data.delete(:time)
          data
        end
      end
    end
  end
end
