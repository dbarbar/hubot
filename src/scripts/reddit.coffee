# reddit (me) <reddit> [limit] - Lookup reddit topic

# Topic lookup from reddit
# Enrique Vidal - enrique@cloverinteractive.com

Select      = require( "soupselect" ).select
HTMLParser  = require "htmlparser"

lookup_site = "http://www.reddit.com/"

module.exports = (robot)->
  robot.respond /reddit( me)? ([a-z0-9\-_\.]+\/?[a-z0-9\-_\.]+)( [0-9]+)?/i, (message)->
    lookup_reddit message, (text)->
      message.send text

  lookup_reddit = (message, response_handler)->
    top     = parseInt message.match[3]
    reddit  = "r/" + message.match[2] + ".json"

    location  = lookup_site + reddit

    message.http( location ).get() (error, response, body)->
      return response_handler "Sorry, something went wrong"                   if error
      return response_handler "Reddit doesn't know what you're talking about" if response.statusCode == 404

      list  = JSON.parse( body ).data.children
      count = 0

      for item in list
        count++

        text = ( item.data.title || item.data.link_title ) + " - " + ( item.data.url || item.data.body )
        response_handler text

        break if count == top

