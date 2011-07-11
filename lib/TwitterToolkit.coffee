
{StreamClient, StreamPlexor} = require './StreamToolkit'

#
#	TwitterStream
#	
#	basic streaming twitter client, implemented as a StreamClient
#	(see StreamToolkit.StreamClient).  Buffers live stream and 
#	emits tweet events as tweets aggregate.
#
class exports.TwitterStream extends StreamClient
	
	# CONSTRUCTOR
	# @parm connectionOptions	set of connection options, a'la http.request
	constructor: (connectionOptions) -> super connectionOptions, /\n*\r\n*/, "tweet"

#
#	TwitterPlexor
#	
#	TwitterStream aggregator and broadcaster.  Registers itself as a listener
#	on all tweet events for added streams and rebroadcasts, essentially 
#	plexing down multiple streams into a single aggregated feed.
#
class exports.TwitterPlexor extends StreamPlexor
	
	constructor:           -> super "tweet"
	
	# addStream
	# @parm stream				StreamClient, preferably a TwitterStream.
	#							This Plexor will register to listen on
	#							tweet events from this stream.
	addStream:    (stream) -> super stream, "tweet"
	
	# removeStream
	# @parm stream				StreamClient previously added to this 
	#							Plexor object.
	removeStream: (stream) -> super stream, "tweet"



