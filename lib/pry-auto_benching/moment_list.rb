#
# MomentList is an Array-like object who cycles its contents
# when a max size is reached.
#
# @api private
#
class Pry::AutoBenching::MomentList
  include Enumerable

  def initialize(pry)
    @pry = pry
    @ary = []
  end

  def each
    @ary.each do |moment|
      yield moment
    end
  end

  def [](index)
    @ary[index]
  end

  def pop
    @ary.pop
  end

  def empty?
    @ary.empty?
  end

  def <<(other)
    @ary.shift if @ary.size + 1 > max_size
    @ary << other
  end

  def max_size
    @pry.config.auto_benching.max_history_size
  end
end
