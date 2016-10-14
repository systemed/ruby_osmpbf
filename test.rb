
	# Parse an .osm.pbf file
	# Requires patched beefcake as per https://github.com/protobuf-ruby/beefcake/issues/61

	require 'beefcake'
	require 'zlib'
	require './classes'
	require './read_block'
	
#	infile  = File.open('/usr/local/share/maps/planet/oxfordshire-latest.osm.pbf', 'rb')
#	outfile = File.open('output.osm.pbf', 'wb')

	infile  = File.open('/Users/richard/Code/C++/protobuf/output.pbf', 'rb')
	outfile = File.open('output2.osm.pbf', 'wb')

	# Read HeaderBlock
	hh,hb=get_block(infile)
	puts hb.inspect
	write_block(outfile, hb, hh)

	# Read PrimitiveBlock data
	while !infile.eof?
		ph,pb=get_block(infile)
		write_block(outfile, pb)
	end

	infile.close
	outfile.close

