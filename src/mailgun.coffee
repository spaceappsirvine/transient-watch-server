Mailgun = require('mailgun').Mailgun;
mg = new Mailgun(process.env.MAILGUN_API);


class Notification

  notify: (email, subject, text, callback) ->
    mg.sendText 'sender@example.com',
             email,
             subject,
             text,
             callback


  getDateString: ->
    x = Date()
    x = x.split(' ')
    y = x[0] + ' ' + x[1] + ' ' + x[2] + ' ' + x[3]
