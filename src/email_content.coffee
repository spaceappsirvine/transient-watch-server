
class EmailContent

  getSubject: (date) ->
    "Updates for #{date}"


  getBodyWithData: (data, threshold = 100) ->
    filtered = item for item in data when Math.abs(item.today - item.yesterday) > threshold
    infoArray = for item in filtered.slice 0,10
      """

        Name:  #{item.name}
        Type:  #{item.type}
        Right Ascention:  #{item.ra}
        Declenation:  #{item.dec}
        Today: #{item.today}
        Yesterday: #{item.yesterday}

      """

    """
      New transient space events

      #{infoArray.join ''}
    """


module.exports = EmailContent
