class SenseApi
  class Device
    def initialize(device_json, monitor, api)
      @monitor = monitor
      @device_json = device_json
      @api = api
    end

    def id
      @device_json["id"]
    end

    def details
      fetch('app/monitors', @monitor.id, 'devices', self.id)
    end

    def history(granularity = :minute)
      fetch("history/usage?monitor_id=#{id}&granularity=minute&frames=3600&start=#{1.hour.ago.to_formatted_s(:iso8601)}")
    end

    def devices
      build_devices(fetch('app/monitors', id, 'status'), @api)
    end

    private
    def fetch(path)
      @app.fetch([path].flatten.join('/'))
    end
  end
end