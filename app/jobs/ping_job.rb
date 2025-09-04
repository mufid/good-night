# Example job that only run with "ping" on the active job runner
class PingJob < ApplicationJob
  def perform
    logger.info "Ping job ran"
  end
end
