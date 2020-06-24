module Pry::AutoBenching
  require 'pry'
  require_relative 'pry-auto_benching/version'
  require_relative 'pry-auto_benching/moment'
  require_relative 'pry-auto_benching/moment_list'
  require_relative 'pry-auto_benching/pry_command'

  @moments = Hash.new do |h, pry|
    h[pry.hash] = MomentList.new(pry)
  end

  @before_eval = ->(_, pry) do
    clock_type = pry.config.auto_benching.clock_type
    k = @moments.key?(pry.hash) ? pry.hash : pry
    @moments[k] << Moment.new(Process.clock_gettime(clock_type))
  end

  @after_eval = ->(_, pry) do
    auto_benching = pry.config.auto_benching
    moment = @moments[pry.hash][-1]
    moment.duration = Process.clock_gettime(auto_benching.clock_type) - moment.start_timestamp.to_f
    if auto_benching.display_duration_if.call(pry, moment.duration)
      moment.input = pry.input_ring.to_a[-1]
      write_duration(pry, moment.duration)
    else
      @moments[pry.hash].pop
      pry.config.forget(:prompt_name)
    end
  end

  @before_session = ->(_, _, pry) do
    Pry::AutoBenching.enable(pry) if pry.config.auto_benching.enabled
  end

  @after_session = ->(_, _, pry) do
    @moments.delete(pry.hash)
  end

  #
  # Enables benchmarking for the param `pry`.
  #
  # @param [Pry] pry
  #   An instance of Pry.
  #
  # @return [void]
  #
  def self.enable(pry)
    if not pry.config.hooks.hook_exists? :before_eval, @before_eval.hash
      pry.config.hooks.add_hook :before_eval, @before_eval.hash, @before_eval
      pry.config.hooks.add_hook :after_eval,  @after_eval.hash , @after_eval
      pry.config.hooks.add_hook :after_session, @after_session.hash , @after_session
    end
  end

  #
  # Disables benchmarking for the param `pry`.
  #
  # @param [Pry] pry
  #   An instance of Pry.
  #
  # @return [void]
  #
  def self.disable(pry)
    pry.config.hooks.delete_hook :before_eval, @before_eval.hash
    pry.config.hooks.delete_hook :after_eval , @after_eval.hash
    pry.config.hooks.delete_hook :after_session , @after_session.hash
    @moments.delete(pry.hash)
  end

  #
  # @return [Pry::AutoBenching::MomentList]
  #   An Array-like object.
  #
  # @api private
  #
  def self.moments
    @moments
  end

  #
  # @api private
  #
  def self.write_duration(pry, duration)
    auto_benching = pry.config.auto_benching
    target = auto_benching.target_display.to_s
    pry.config.forget(:prompt_name)
    if target == 'prompt'
      pry.config.prompt_name = Pry::Helpers::Text.send auto_benching.prompt_color,
                                                       format_duration(duration)
    elsif target == 'none'
      # no op
    else
      pry.output.warn "_pry_.config.auto_benching.target_display has an invalid value: \n" \
                      "#{auto_benching.target_display.inspect}\n" \
                      "Valid values are: " \
                      "#{Pry::AutoBenching::PryCommand::VALID_TARGET_DISPLAYS.join(', ')}"
    end
  end

  #
  # @api private
  #
  def self.format_duration(float)
    duration = Kernel.sprintf("%.2f", float).ljust(4)
    "#{duration}s "
  end

  Pry.configure do |config|
    config.hooks.add_hook :before_session, @before_session.hash, @before_session
    config.auto_benching = Pry::Config.from_hash({
      max_history_size: 70,
      enabled: true,
      target_display: :prompt,
      prompt_color: :green,
      clock_type: Process::CLOCK_MONOTONIC,
      display_duration_if: ->(pry, duration) { duration >= 0.01 }
    })
  end
end
