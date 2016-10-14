
	# Debug parsing of an .osm.pbf file
	# Requires patched beefcake as per https://github.com/protobuf-ruby/beefcake/issues/61

	require 'beefcake'
	require 'zlib'
	require './classes'
	require './read_block'
	
	infile  = File.open(ARGV[0], 'rb')

	# Read HeaderBlock
	hh,hb=get_block(infile)
	puts hb.inspect

	# Read PrimitiveBlock data
	ct = 0
	while !infile.eof?
		ph,pb=get_block(infile)
		puts ct
		if ct==38
			puts pb.inspect
			puts
		end
		ct+=1
	end

	infile.close

