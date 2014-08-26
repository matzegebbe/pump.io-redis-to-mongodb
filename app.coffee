# Copyright 2014 Mathias Gebbe <mathias.gebbe@gmail.com>
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
  driver: "mongodb"
  params: {"host":"localhost","dbname": "pumpio"}

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
