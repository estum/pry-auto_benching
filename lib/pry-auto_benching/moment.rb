#
# A Struct that contains information about a input moment in Pry.
#
# @api private
#
class Pry::AutoBenching::Moment < Struct.new(:start_timestamp)
  attr_accessor :input
  attr_accessor :duration
end
