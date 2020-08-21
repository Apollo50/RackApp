class TimeFormat
  TIME_KEY = {"year" => "%Y", "month" => "%m", "day" => "%d", "hour" => "%H", "minute" => "%M", "second" => "%S"}

  def initialize(params)
    @params = params
    @invalid_params = unknown_format_key
  end

  def result
    Time.now.strftime(time_by_format) + "\n"
  end

  def valid?
    @invalid_params.empty?
  end

  def call
    @invalid_params
  end

  private

  def unknown_format_key
    @params - TIME_KEY.keys
  end

  def time_by_format
    time = []
    @params.each { |key| time << TIME_KEY[key] }
    time.join('-')
  end
end
