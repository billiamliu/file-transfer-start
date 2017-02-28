require_relative '../../automated_init'

context 'handle command' do
	handler = Handlers::Commands.new

	clock_time = Controls::Time::Raw.example
	time = Controls::Time::ISO8601.example(clock_time)

	handler.clock.now = clock_time

	initiate = Controls::Commands::Initiate.example

	handler.(initiate)

	context 'Initiate' do
		writes = handler.write.writes do |written_event|
			written_event.class.message_type == 'Initiated'
		end

		initiated = writes.first.data.message

		test 'Initiated event is written' do
			refute(initiated.nil?)
		end

		context 'Recorded stream attributes' do
			test 'File id set' do
				assert(initiated.file_id == initiate.file_id)
			end

			test 'File name set' do
				assert(initiated.name == initiate.name)
			end

  			test 'File temp_path set' do
				assert(initiated.temp_path == initiate.temp_path)
			end
			
			test 'File time set' do
				assert(initiated.time == initiate.time)
			end

			test 'File processed_time set' do
				assert(initiated.processed_time == time)
			end

			test 'File has no nils' do
				initiated.attributes.each do |attr,val|
					refute(val.nil?)
				end
			end

		end


	end
end