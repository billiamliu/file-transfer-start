module FileTransferComponent
  module Handlers
    class Events
      class Initiated
        include Messaging::Handle
        include Messaging::Postgres::StreamName # includes the stream_name method
        include FileTransferComponent::Messages::Commands
        include FileTransferComponent::Messages::Events
        include Log::Dependency

        dependency :write, Messaging::Postgres::Write
        dependency :clock, Clock::UTC
        dependency :store, FileTransferComponent::Store

        def configure
          Messaging::Postgres::Write.configure self
          Clock::UTC.configure self
          FileTransferComponent::Store.configure self
        end

        category :file_transfer

        handle Initiated do |initiated|
          # talking to S3 using a dep
        end
      end
    end
  end
end
