# pry-auto_benching.rb

* <a href="#introduction">Introduction</a>
* <a href='#configuration'>Configuration (optional)</a>
* <a href='#examples'>Examples</a>
* <a href='#accuracy'>Accuracy</a>
* <a href='#install'>Install</a>
* <a href='#license'>License</a>

## <a id='introduction'>Introduction</a>

Automatic benchmarking inside the Pry REPL.

## <a id='configuration'>Configuration (optional)</a>

Configuration can be skipped unless you want to change the defaults.  
To change the defaults, open `~/.pryrc` in your editor of choice and change  
one or more of the following:  

```ruby
Pry.configure do |config|
  #
  # Start benchmarking when Pry starts?
  # The default is true.
  #
  config.auto_benching.enabled = false

  #
  # The max number of previous benchmark results to store in memory,
  # for use by `auto-benching --past`. The default is 70.
  #
  config.auto_benching.max_history_size = 120

  #
  # The type of clock to use, default is Process::CLOCK_MONOTONIC.
  # See https://www.rubydoc.info/stdlib/core/Process:clock_gettime
  #
  config.auto_benching.clock_type = Process::CLOCK_REALTIME

  #
  # Configure where benchmark results will be displayed.
  # Accepted options are:
  #
  # * prompt
  #   The default, results are written to the prompt.
  #
  # * none
  #   Results are not displayed but are still recorded and can be
  #   viewed on demand by running 'auto-benching --past'.
  #
  config.auto_benching.target_display =  ':prompt | :none'

  #
  # Define a Proc that decides whether or not to record or display benchmark
  # results. The default condition is 'duration >= 0.01'.
  #
  config.auto_benching.display_duration_if = ->(pry, duration) { duration >= 0.02 }

  #
  # The color to use for benchmark results when `target_display` is :prompt.
  # The default is :green.
  #
  config.auto_benching.prompt_color = :red
end
```

## <a id='examples'>Examples</a>

__1.__

Get started by reading the help menu:

    [1] pry(main)> auto-benching -h
    Usage: auto-benching [options] [enable|disable]

    The auto-benching command can enable, disable, and
    provide other features related to pry-auto_benching.rb

        -v, --version             Display version.
        -p, --past                Display past benchmark results.
        -t, --target-display      Choose the target display for results. Valid options are: prompt, none
        -h, --help                Show this message.

__2.__

The prompt is updated with benchmark results, this happens to be the default:

    [1] pry(main)> sleep 0.2
     => 0
    [2] 0.2s (main)> Net::HTTP.get_response URI.parse('https://github.com')
     => #<Net::HTTPOK 200 OK readbody=true>
    [3] 1.34s (main)> Net::HTTP.get_response URI.parse('https://www.ruby-lang.org')
     => #<Net::HTTPOK 200 OK readbody=true>
    [4] 1.53s (main)>

__3.__

`auto-benching --past` shows past benchmark results:

    [1] 1.30s (main)> auto-benching -past
     1 0.01 sleep 0.01
     2 0.02 sleep 0.02
     3 0.03 sleep 0.03
     4 1.30 sleep 1.3
     5 1.40 Net::HTTP.get_response(URI.parse('https://github.com'))
    [2] pry(main)>

__4.__

Benchmarking can be temporarily disabled then enabled again:

    [1] pry(main)> auto-benching disable
    pry-auto_benching.rb: stopped benchmarking.
    [2] pry(main)> auto-benching enable
    pry-auto_benching.rb: started benchmarking.

## <a id='accuracy'>Accuracy</a>

pry-auto_benching.rb can measure down to 10 milliseconds (0.01 = 10ms).  
When I benchmarked `sleep 0.01` I saw no overhead in the results:

    [1] pry(main)> sleep 0.01
    => 0
    [2] 0.01s (main)>

But that's not to say results can't be reported inaccurately since the benchmark  
includes a **very** small number of method calls to Pry internals, and it could  
include time spent by other Pry plugins who run before/after eval hooks as well.  
I have seen inaccuracies of 10ms (0.01) but not all the time.  


## <a id='install'>Install</a>

    gem install pry-auto_benching.rb

## <a id='license'>License</a>

This project uses the MIT license, see [LICENSE.txt](LICENSE.txt) for details.
