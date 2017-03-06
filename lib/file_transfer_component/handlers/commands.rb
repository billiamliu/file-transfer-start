module FileTransferComponent
  module Handlers
    class Commands
      include Messaging::Handle
      include Messaging::Postgres::StreamName # the stream_name method
      include FileTransferComponent::Messages::Commands
      include FileTransferComponent::Messages::Events
      include Log::Dependency

      dependency :write, Messaging::Postgres::Write
      dependency :clock, Clock::UTC
      dependency :store, FileTransferComponent::Store

      def configure
        Messaging::Postgres::Write.configure self
        FileTransferComponent::Store.configure self
        Clock::UTC.configure self
      end

      category :file_transfer

      handle Initiate do |initiate|
        # SCHEMA
        # initiate.file_id = ID.example
        # initiate.name = "some_name"
        # initiate.temp_path = "some_temp_path"
        # initiate.time = Controls::Time.example

        # get file id from file entity
        file_id = initiate.file_id
        
        # file object; projects the file in its current version of its entire life existence
        # solves concurrency issues when there are two writes on the same file object
        # e.g. I'm the next version of this file entity
        file, stream_version = store.get( file_id, include: :version )
        unless file.nil?
          logger.debug "#{ initiate } command was ignored. File transfer #{ file_id } was already initiated"
          return
        end

        # can sort on this timestamp
        time = clock.iso8601

        # returns an initiated struct
        # `follow` chains the life of the events, the history of where everything comes
        # from, and its reply-to address
        # it's useful for debugging an entity that's been through many services
        file_transfer_initiated = Initiated.follow( initiate )

        # actual time we are processing the event
        file_transfer_initiated.processed_time = time

        # file_transfer: id from the category
        # you may be replying to another steam
        stream_name = stream_name( file_id ) # from the Messaging::StreamName
        
        # 
        write.( file_transfer_initiated, stream_name, expected_version: stream_version )
      end

    end
  end
end
