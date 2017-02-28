module FileTransferComponent
  module Messages
    module Events
      class Initiated
        include Messaging::Message

        attribute :file_id, String
        attribute :name, String
        attribute :temp_path, String
        attribute :time, String
        attribute :processed_time, String
      end
    end
  end
end
