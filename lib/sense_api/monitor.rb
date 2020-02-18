class SenseApi
  class Monitor
    def initialize(monitor_json, api)
      @monitor_json = monitor_json
      @api = api
    end

    def id
      @monitor_json["id"]
    end

    def status
      fetch('app/monitors', id, 'status')
    end

    def history(granularity = :minute)
      fetch("history/usage?monitor_id=#{id}&granularity=minute&frames=3600&start=#{1.hour.ago.to_formatted_s(:iso8601)}")
    end

    def trends(scale = :hour)
      fetch("history/trends?monitor_id=#{id}&device_id=usage&scale=hour&start=#{1.month.ago.to_formatted_s(:iso8601)}")
    end

    def devices(force = false)
      @devices = nil if force
      @devices ||= build_devices(fetch('app/monitors', id, 'status'))
    end

    private
    def fetch(path)
      @app.fetch([path].flatten.join('/'))
    end

    def build_devices(devices_json)
      devices_json.map{|json| SenseApi::Device.new(json, self, @api)}
    end
  end
end