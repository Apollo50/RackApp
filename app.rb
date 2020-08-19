class App
  TIME_KEY = %w(year month day hour minute second)
  TIME_METHODS = {year: Time.now.year,
                  month: Time.now.month,
                  day: Time.now.day,
                  hour: Time.now.hour,
                  minute: Time.now.min,
                  second: Time.now.sec}

  def call(env)
    @query = env["QUERY_STRING"]
    @path = env["REQUEST_PATH"]
    @query_params = (Rack::Utils.parse_nested_query(@query)).values.join.split(",")
    [status, headers, body]
  end

  private

  def status
    if unknown_format_key.empty? && valid_path?
      200
    elsif unknown_format_key.any? && valid_path?
      400
    else
      404
    end
  end

  def headers
    {'Content-type' => 'text/plain'}
  end

  def body
    if unknown_format_key.empty? && valid_path? && !@query_params.empty?
      [time_by_format]
    elsif unknown_format_key.any? && valid_path?
      ["Unknown time format [#{unknown_format_key.join(',')}]\n"]
    else
      ["Invalid path or empty params\n"]
    end
  end

  def unknown_format_key
    @query_params - TIME_KEY
  end

  def time_by_format
    time = []
    @query_params.each do |key|
      time << TIME_METHODS[key.to_sym]
    end
    time.join('-') + "\n"
  end

  def valid_path?
    @path == '/time'
  end
end