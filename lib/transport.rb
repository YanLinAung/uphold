module Uphold
  class Transport
    include Logging
    include Compression

    attr_reader :tmpdir

    def initialize(params)
      @tmpdir = Dir.mktmpdir('uphold')
      @path = params[:path]
      @filename = params[:filename]
      @folder_within = params[:folder_within]

      @date_format = params[:date_format] || '%Y-%m-%d'
      @date_offset = params[:date_offset] || 0
      @path.gsub!('{date}', (Date.today - @date_offset).strftime(@date_format))
      @filename.gsub!('{date}', (Date.today - @date_offset).strftime(@date_format))
    end

    def fetch
      logger.info "Transport starting #{self.class}"
      logger.debug "Temporary directory '#{@tmpdir}'"

      t1 = Time.now
      path = fetch_backup
      t2 = Time.now
      delta = t2 - t1
      if path.nil?
        logger.fatal "Transport failed! (#{format('%.2f', delta)}s)"
        touch_state_file('bad_transport')
        exit 1
      else
        logger.info "Transport finished successfully (#{format('%.2f', delta)}s)"
        path
      end
    rescue => e
      touch_state_file('bad_transport')
      raise e
    end

    def fetch_backup
      fail "Your transport must implement the 'fetch' method"
    end
  end
end
