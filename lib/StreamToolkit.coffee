
sys    = require 'sys'
events = require 'events'
http   = require 'http'


#
#	StreamClient
#
#	Generic node client encapsulation.  StreamClients are EventEmitters
#	and will rebroadcast data events from the response stream.
#
class exports.StreamClient extends events.EventEmitter
	
	# CONSTRUCTOR
	# @parm connectionOptions 		connection options a'la http.request
	# @parm delim					buffer delimiter
	# @parm event					event type to emit on data events from
	#								the response stream
	constructor: (@connectionOptions, @delim, @event) -> @buffer = ""
	
	# stream
	# this method creates the request and attaches the response
	# stream to this object.
	stream: ->
		req = http.request @connectionOptions, (res) =>
			@res = res
			res.setEncoding('utf8')
			res.on 'data', (chunk) =>
				@buffer += chunk
				parts    = @buffer.split @delim
				len      = parts.length

				if len > 1
					@buffer = parts.pop()
					@emit @event, part for part in parts[0 ... len]
		req.end();

	# pause
	# pause the response stream, provided there is an active response.
	pause:  -> @res?.pause()
	
	# resume
	# resume the response stream, provided there is an active response.
	resume: -> @res?.resume()


#
#	StreamPlexor
#
#	Generic StreamClient multiplexor.  As streams are added, the StreamPlexor
#	registers itself as a listener and rebroadcasts.
#
class exports.StreamPlexor extends events.EventEmitter
	
	# CONSTRUCTOR
	# @parm event					the event id that we want to emit on rebroadcast
	constructor:         (@event) ->
	
	# removeStream
	# unregister this plexor from a stream
	# @parm stream					stream we may be registered on
	# @parm event					event we want to unregister from
	removeStream: (stream, event) -> stream.removeListener event, @

	# @parm stream					stream to register on and rebroadcast
	# @parm event					event to listen for on supplied stream
	addStream:    (stream, event) -> 
		stream.on event, (data) => @emit @event, data
		stream.stream()