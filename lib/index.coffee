mimemessage = require 'mimemessage'
_  = require 'lodash'

exports.multiRes = (req, res, next) ->
	res.sendMulti = (data, noHeaders = true) ->
		msg = buildBatch(data)
		res.set('content-type', msg.header('content-type'))
		res.end(msg.toString({ noHeaders: noHeaders }), 'utf8')
	next()


buildBatch = (data) ->
	msg = mimemessage.factory { contentType: 'multipart/mixed', body: [] }

	msg.body = data.map (d) ->
		if _.isArray d then buildBatch d, false
		else mimemessage.factory d

	return msg
