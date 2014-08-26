pump.io-redis-to-mongodb
========================

converts a pump.io redisdb to mongodb (using abstraction layer databank)

i had to change databank-redis to get the hole keys. so i put the node_modules in the repo
(you only need to overwrite /node_modules/databank/node_modules/databank-redis/lib/redis.js)

configure config_source and config_target in app.coffee
