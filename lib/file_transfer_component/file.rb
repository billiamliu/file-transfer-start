module FileTransferComponent
  class File
    include Schema::DataStructure

    attribute :id, String
    attribute :name, String
    attribute :size, String
    attribute :type, String
  end
end
