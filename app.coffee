tabs = [
  "accesstoken"
  "activity"
  "alert"
  "application"
  "article"
  "audio"
  "badge"
  "binary"
  "bookmark"
  "client"
  "collection"
  "comment"
  "confirmation"
  "credentials"
  "device"
  "dialbackrequest"
  "edge"
  "event"
  "favorite"
  "file"
  "game"
  "group"
  "host"
  "image"
  "issue"
  "job"
  "membership"
  "nonce"
  "note"
  "offer"
  "organization"
  "other"
  "page"
  "person"
  "place"
  "process"
  "product"
  "proxy"
  "question"
  "recovery"
  "recentdialbackrequests"
  "remoteaccesstoken"
  "remoterequesttoken"
  "requesttoken"
  "review"
  "service"
  "session"
  "share"
  "stream"
  "streamcount"
  "streamsegment"
  "streamsegmentcount"
  "streamsegments"
  "task"
  "user"
  "usercount"
  "userlist"
  "video"
]

databank = require 'databank'
Databank = databank.Databank
async = require 'async'
_ = require 'underscore'

config_source =
  driver: "redis"
  params: {"host":"localhost","database":5,"port":6379}

config_target =
  "driver": "mongodb"
  "params": {"host":"localhost","dbname": "pumpio"}

dbs = Databank.get(config_source.driver, config_source.params)
dbt = Databank.get(config_target.driver, config_target.params)

async.waterfall [
  (callback) ->
    dbs.connect config_source.params, callback
  (callback) ->
    dbt.connect config_target.params, callback
  (callback) ->
    async.each tabs, ((tabname, callb) ->
      console.log "processing: " + tabname
      dbs.scan tabname
      , ((result) ->
        #console.log result[0]
        #console.log result[1]
        dbt.save(tabname, result[0], result[1], (saved) ->
          #console.log "done with: " + tabname
          )
        return
      ), (err) ->
        if err
          console.log err
        callb()
    ), (err) ->
      if err
        console.log "failed to process" + err
      else
        console.log "All have been processed successfully"
      callback(null,'done')
], (err, result) ->
    process.exit(0);
