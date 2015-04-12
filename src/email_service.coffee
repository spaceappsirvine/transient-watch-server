Mailgun = require('mailgun').Mailgun;

class EmailService

  constructor: ->
    @client = new Mailgun(process.env.MAILGUN_API_KEY);


  send: (email, subject, text, callback = (->)) ->
    @client.sendText 'notifications@galacticgiants.com', email, subject, text, callback


  getDateString: ->
     now = Date.now()
     "#{now.getMonth() + 1}/#{now.getDate()}/#{now.getFullYear()}"


module.exports = EmailService
