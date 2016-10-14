
	def get_header(file)
		# Read a BlobHeader
		length = file.read(4).unpack('N')[0]
		BlobHeader.decode(file.read(length))
	end

	def get_data(file,header,cl)
		# Read a Blob (length comes from the preceding header)
		blob = Blob.decode(file.read(header.datasize))
		blob_z = Zlib::Inflate.inflate(blob.zlib_data)
		cl.decode(blob_z)
	end

	def get_block(file)
		# Combine the two above methods to read a block
		header = get_header(file)
		puts header.inspect
		case header.type
			when 'OSMHeader'; [ header, get_data(file,header,HeaderBlock) ]
			when 'OSMData';   [ header, get_data(file,header,PrimitiveBlock) ]
			else;             raise "Unexpected block type: #{header.type}"
		end
	end

	def write_block(file,block,header=nil)
		# Encode data
		blob = Blob.new
		blob.zlib_data = Zlib::Deflate.deflate(block.encode)
		blob_encoded = blob.encode

		# Encode header
		if header.nil? then header = BlobHeader.new end
		header.type = case block
			when HeaderBlock;	'OSMHeader'
			when PrimitiveBlock;'OSMData'
			else;				raise "Unexpected class: #{block.class}"
		end
		header.datasize = blob_encoded.length
		header_encoded  = header.encode

		# Write
		file.write([header_encoded.length].pack('N'))
		file.write(header_encoded)
		file.write(blob_encoded)
	end
