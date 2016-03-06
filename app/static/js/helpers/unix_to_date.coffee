module.exports = (unix_timestamp) ->
    # convert a timestamp like '1457303127' to 3/5/16.

    date = new Date(unix_timestamp*1000)
    month = date.getMonth() + 1 # months are zero indexed
    day_of_month = date.getDate()
    year = date.getFullYear().toString().slice(2)

    return "#{month}/#{day_of_month}/#{year}"
