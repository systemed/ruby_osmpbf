	class Info
		include Beefcake::Message
		optional :version,   :int32, 1, :default => -1
		optional :timestamp, :int32, 2
		optional :changeset, :int64, 3
		optional :uid,       :int32, 4
		optional :user_sid,  :int32, 5
		optional :visible,   :bool , 6
	end

	class Node
		include Beefcake::Message
		required :id,   :sint64, 1
		required :lat,  :sint64, 7
		required :lon,  :sint64, 8
		repeated :keys, :uint32, 9 , :packed => true
		repeated :vals, :uint32, 10, :packed => true
		optional :info, Info, 11
	end
	
	class Way
		include Beefcake::Message
		required :id,   :int64 , 1
		repeated :keys, :uint32, 2, :packed => true
		repeated :vals, :uint32, 3, :packed => true
		optional :info, Info   , 4
		repeated :refs, :sint64, 8, :packed => true
	end
	
	class Relation
		include Beefcake::Message
		module MemberType
			NODE = 0
			WAY = 1
			RELATION = 2
		end
		required :id,        :int64 , 1
		repeated :keys,      :uint32, 2, :packed => true
		repeated :vals,      :uint32, 3, :packed => true
		optional :info,      Info   , 4
		repeated :roles_sid, :int32 , 8, :packed => true
		repeated :memids,    :sint64, 9, :packed => true
		repeated :types,     MemberType, 10, :packed => true
	end
	
	class DenseInfo
		include Beefcake::Message
		repeated :version,   :int32 , 1, :packed => true
		repeated :timestamp, :sint64, 2, :packed => true
		repeated :changeset, :sint64, 3, :packed => true
		repeated :uid,       :sint32, 4, :packed => true
		repeated :user_sid,  :sint32, 5, :packed => true
		repeated :visible,   :bool  , 6, :packed => true
	end

	class DenseNodes
		include Beefcake::Message
		repeated :id,        :sint64, 1, :packed => true
		optional :denseinfo, DenseInfo, 5
		repeated :lat,       :sint64, 8, :packed => true
		repeated :lon,       :sint64, 9, :packed => true
		repeated :keys_vals, :int32 , 10, :packed => true
	end

	class BlobHeader
		include Beefcake::Message
		required :type, :string, 1
		optional :indexdata, :bytes, 2
		required :datasize, :int32, 3
	end
	
	class Blob
		include Beefcake::Message
		optional :raw, :bytes, 1
		optional :raw_size, :int32, 2
		optional :zlib_data, :bytes, 3
	end
	
	class HeaderBBox
		include Beefcake::Message
		required :left,   :sint64, 1
		required :right,  :sint64, 2
		required :top,    :sint64, 3
		required :bottom, :sint64, 4
	end

	class HeaderBlock
		include Beefcake::Message
		optional :bbox, HeaderBBox, 1
		repeated :required_features, :string, 4
		repeated :optional_features, :string, 5
		optional :writing_program, :string, 16
		optional :source, :string, 17
		optional :osmosis_replication_timestamp, :int64, 32
		optional :osmosis_replication_sequence_number, :int64, 33
		optional :osmosis_replication_base_url, :string, 34
	end

	class Changeset
		include Beefcake::Message
		required :id,   :int64, 1
		repeated :keys, :uint32, 2, :packed => true
		repeated :vals, :uint32, 3, :packed => true
		optional :info, Info, 4
		required :created_at, :int64, 8
		optional :closetime_delta, :int64, 9
		required :open, :bool, 10
		optional :bbox, HeaderBBox, 11
	end

	class StringTable
		include Beefcake::Message
		repeated :s, :bytes, 1
		# could probably be :string - see https://help.openstreetmap.org/questions/24589/why-is-the-pbf-stringtable-defined-to-use-byte
	end

	class PrimitiveGroup
		include Beefcake::Message
		repeated :nodes, Node, 1
		optional :dense, DenseNodes, 2
		repeated :ways, Way, 3
		repeated :relations, Relation, 4
		repeated :changesets, Changeset, 5
	end

	class PrimitiveBlock
		include Beefcake::Message
		required :stringtable, StringTable, 1
		required :primitivegroup, PrimitiveGroup, 2
		optional :granularity, :int32, 17, :default => 100
		optional :lat_offset, :int64, 19, :default => 0
		optional :lon_offset, :int64, 20, :default => 0
		optional :date_granularity, :int32, 18, :default => 1000
	end
