$redis = Redis.new(host: 'localhost', port: 6379, driver: :hiredis)

class << $redis

  # def fetch(key, default=nil)
  #   $redis.get(key) || default
  # end

  # Hack to deserialize a redis list of JSON objects stored as a string
  # into an array of ruby hashes
  def get_json_list(key)
    str = "[" <<  $redis.lrange(key, 0, -1).join(',') << "]"
    JSON.parse(str)
  end

end
