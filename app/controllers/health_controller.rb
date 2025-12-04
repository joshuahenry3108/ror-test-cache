class HealthController < ApplicationController
  def show
    hits = 0
    test_value = nil
    redis_connected = false
    error_message = nil

    begin
      # Test Redis connection first
      redis_connected = Rails.cache.redis&.connected? rescue false
      Rails.logger.info "Redis connection status: #{redis_connected}"

      # Increment hit counter
      current_hits = Rails.cache.read('health_hits')
      Rails.logger.info "Current hits from cache: #{current_hits.inspect}"
      
      if current_hits.nil?
        hits = 1
        Rails.cache.write('health_hits', hits)
        Rails.logger.info "Initialized health_hits to: #{hits}"
      else
        hits = current_hits.to_i + 1
        Rails.cache.write('health_hits', hits)
        Rails.logger.info "Incremented health_hits to: #{hits}"
      end 

      # Set a test value with explicit options
      test_key = 'redis_test_key'
      test_data = "hello_redis_#{Time.now.to_i}"
      
      write_result = Rails.cache.write(test_key, test_data, expires_in: 60.seconds)
      Rails.logger.info "Write result for #{test_key}: #{write_result}"
      
      # Read it back
      test_value = Rails.cache.read(test_key)
      Rails.logger.info "Redis test key (#{test_key}) set to: '#{test_data}' and read back: '#{test_value}'"
      
      # Verify they match
      if test_value != test_data
        Rails.logger.warn "⚠️ Mismatch! Wrote: '#{test_data}', Read: '#{test_value}'"
      end

    rescue => e
      error_message = e.message
      Rails.logger.error "❌ Redis error: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.first(5).join("\n")
    end

    render json: { 
      status: 'ok', 
      redis_connected: redis_connected,
      hits: hits, 
      test_value: test_value,
      error: error_message
    }, status: :ok
  end
end