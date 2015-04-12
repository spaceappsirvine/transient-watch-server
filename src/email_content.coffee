
class EmailContent

  #generate: (data) ->

    output = "New transient space events!"

    for item in data
      filtered = []
      threshold = # 30;
      criterion = # today-yesterday

      if ( criterion > threshold)
        filtered.push(item)

      filtered.slice(0,10)

      for item in filtered
        output = output + "\nName: " + item.name + 
        output = output + "\n\nType: " + item.type + 
        output = output + "\n\nRight Ascention: " + item.ra
        output = output + "\n\nDeclenation: " + item.dec
        output = output + "\n\nToday: " + item.today
        output = output + "\n\nYesterday: " + item.yesterday

    output


module.exports = EmailContent