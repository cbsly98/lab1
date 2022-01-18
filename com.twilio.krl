ruleset com.twilio {
    meta {
        name "twilio module"
        author "Caleb Sly"
        description <<
          A module for twilio
        >>
        configure using
          username = ""
          password = ""
          fromNumber = ""
        provides getMessagesPage, messages, sendMessage
      }
      global {
        base_url = "https://api.twilio.com/2010-04-01"
    
        getMessagesPage = function() {
            response = http:get(<<#{base_url}/Accounts/#{username}/Messages.json>>, auth = {"username": username, "password": password})
            response{"content"}.decode()
        }

        messages = function(toNumber, fromNumber) {
          queryString = {"To" : toNumber, "From" : fromNumber}.klog("queryString: ")
          response = http:get(<<#{base_url}/Accounts/#{username}/Messages.json>>.klog("url: "), auth = {"username": username, "password": password}, qs = queryString)
            response{"content"}.decode()
        }

        sendMessage = defaction(toNumber, messageBody) {
            content = {"From" : fromNumber, "To" : toNumber, "Body" : messageBody}.klog("content: ")
            http:post(<<#{base_url}/Accounts/#{username}/Messages>>.klog("url"), form=content, auth = {"username": username, "password": password}) setting(response)
            return response
        }
      }
}