module FileTransferComponent
  class Projection
    include EntityProjection
    include Messages::Events

    entity_name :file

    apply Initiated do |initiated|
      file.name = initiated.name # has all teh values of the event
    end

  end
end
