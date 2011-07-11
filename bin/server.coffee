
sys = require 'sys'
http = require 'http'
{ TwitterStream, TwitterPlexor } = require '../lib/TwitterToolkit'

###

	for testing, you can supply your credentials on the 
	command line:
		
		coffee bin/server.coffee <twitter.username> <twitter.password>

###
credentials = 
	username: process.argv[2]
	password: process.argv[3]
	auth:     new Buffer(process.argv[2] + ":" + process.argv[3]).toString('base64')

###

	testing request options, a default to lock into the 
	downsampled twitter firehose stream.

###
options = 
	host:     'stream.twitter.com'
	port:     '80'
	method:   'GET'
	path:     '/1/statuses/sample.json'
	headers:
		"Authorization": "Basic #{credentials.auth}"
		"content-type":  "application/json"


###

	test

###

twitterBroadcast = new TwitterPlexor()
twitterBroadcast.on "tweet", (tweet) -> console.log tweet; console.log '\n---------------------------------------------------\n'

twitterBroadcast.addStream new TwitterStream options
twitterBroadcast.addStream new TwitterStream options
