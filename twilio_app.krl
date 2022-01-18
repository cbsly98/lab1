ruleset twilio_app {
  meta {
    name "Twilio App"
    description <<
    An App for testing Twilio Module
    >>
    author "Caleb Sly"
    use module com.twilio alias twilio
        with 
            username = ctx:rid_config{"username"}
            password = ctx:rid_config{"password"}
            fromNumber = ctx:rid_config{"fromNumber"}
    shares getMessagesPage, lastResponse, messages
  }

  global {
    getMessagesPage = function() {
      twilio:getMessagesPage()
    }
    lastResponse = function() {
      {}.put(ent:lastTimestamp,ent:lastResponse)
    }
    messages = function(toNumber, fromNumber) {
      twilio:messages(toNumber, fromNumber)
    }
  }

  rule send_message {
    select when sms new_message
      toNumber re#(.+)#
      messageBody re#(.+)#
      setting(toNumber, messageBody)
    twilio:sendMessage(toNumber, messageBody) setting(response)
    fired {
      ent:lastResponse := response
      ent:lastTimestamp := time:now()
    }
  }

}