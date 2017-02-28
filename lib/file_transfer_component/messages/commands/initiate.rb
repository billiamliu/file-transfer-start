module FileTransferComponent
  module Messages
    module Commands
      class Initiate
        include Messaging::Message

        attribute :file_id, String
        attribute :name, String
        attribute :temp_path, String
        attribute :time, String
      end
    end
  end
end
