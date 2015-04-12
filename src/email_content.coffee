
class EmailContent

  getSubject: (date) ->
    "Updates for #{date}"


  getBodyWithData: (data, threshold = 100) ->
    getMeasurement =  (strValue) ->
      if strValue is '-' then 0 else parseInt strValue.split(' ')[0]

    changeEvent = (event) ->
      today = getMeasurement event.today
      yesterday = getMeasurement event.yesterday
      Math.abs today - yesterday


    filtered = (item for item in data when changeEvent(item) > threshold)
    infoArray = for item in filtered.slice 0,10
      """
      Name: #{item.name}
      Type: #{item.type}
      Right Ascention: #{item.ra}
      Declenation: #{item.dec}
      Today: #{item.today}
      Yesterday: #{item.yesterday}

      """

    """
      New transient space events

      #{infoArray.join ''}
    """



module.exports = EmailContent
