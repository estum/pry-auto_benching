class Pry::AutoBenching::PryCommand < Pry::ClassCommand
  extend Pry::Helpers::Text
  VALID_TARGET_DISPLAYS = %w[prompt none]
  VERSION_STRING = <<-VERSION.each_line.map(&:strip).join("\n")
    #{bold('pry-auto_benching.rb')} #{bold("v#{Pry::AutoBenching::VERSION}")}
    --
    If you found a bug, have a suggestion or an improvement to make please open an
    issue / pull request at https://github.com/r-obert/pry-auto_benching.rb
  VERSION

  match 'auto-benching'
  command_options argument_required: true
  group 'pry-auto_benching.rb'
  description 'For enabling and disabling benchmarking and other related features.'
  banner <<-CMDBANNER
  Usage: auto-benching [options] [enable|disable]

  The auto-benching command can enable, disable, and
  provide other features related to pry-auto_benching.rb
  CMDBANNER

  def options(o)
    o.on :v, :version, 'Display version.'
    o.on :p, :past, 'Display past benchmark results.'
    o.on :t=,
         :'target-display=',
         'Choose the target display for results. Valid options are: ' +
         VALID_TARGET_DISPLAYS.join(', ')
  end

  def process(command)
    case
    when opts.version? then page(VERSION_STRING)
    when opts.present?('target-display') then change_target_display(opts[:'target-display'])
    when opts.present?('past') then read_past_benchmarks
    else
      if command == 'enable'
        Pry::AutoBenching.enable(_pry_)
        page('pry-auto_benching.rb: benchmarking.')
      elsif command == 'disable'
        Pry::AutoBenching.disable(_pry_)
        page('pry-auto_benching.rb: stopped benchmarking.')
      else
        raise Pry::CommandError,
              "'#{command}' is not implemented by this command, add -h for help."
      end
    end
  end

  private

  def read_past_benchmarks
    moments = Pry::AutoBenching.moments[_pry_.hash]
    if moments.empty?
      page "No benchmark results are stored for this session."
    else
      page moments.map.with_index {|moment,i|
        format "%{i} %{duration}%{code}",
          i: bold(i+1),
          code: moment.input.chomp,
          duration: green(
            Pry::AutoBenching.format_duration(moment.duration).sub('s', '')
          )
      }.join("\n")
    end
  end

  def change_target_display(target_display)
    if VALID_TARGET_DISPLAYS.include?(target_display)
      _pry_.config.auto_benching.target_display = target_display
      page "Display changed to '#{target_display}'"
    else
      raise Pry::CommandError, "'#{target_display}' is invalid, " \
                               "valid options are: #{VALID_TARGET_DISPLAYS.join(', ')}"
    end
  end

  def page(str)
    _pry_.pager.page str
  end

  Pry.commands.add_command(self)
end
