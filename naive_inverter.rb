# this is going to be shitty

# a class to approximate and invert VERY NICE functions like low-order polys
# probably unstable as balls
class Functionoid
  attr_accessor :range, :n, :delta, :values

  # find index of range that contains value
  # assumes arr is sorted
  def locate_range(arr, value)
    puts "value #{value}"
    loidx = 0
    hiidx = arr.length - 1

    until hiidx <= loidx + 1 do
      puts "loidx #{loidx}"
      puts "hiidx #{hiidx}"
      print 'mididx '
      puts mididx = (loidx + hiidx) / 2
      print 'rbottom '
      puts rbottom = arr[mididx]
      print 'rtop '
      puts rtop = arr[mididx + 1]
      if (rbottom..rtop).include? value
        return mididx
      elsif value < rbottom
        hiidx = mididx
      elsif value > rtop
        loidx = mididx
      else
        raise 'this shouldn\'t happen'
      end
    end
  end

  def lerp(xa, ya, xb, yb, x)
    ya + (yb - ya) * (x - xa) / (xb - xa)
  end

  def initialize(func, range, n)
    @keys_arr = [] # to ensure sorted-ness
    @values = {}
    @next_value = {}
    @range = range
    @n = n
    @delta = (@range.max - @range.min) / @n.to_f # when in doubt, crank up n
    x = @range.min
    @n.times do |i|
      @keys_arr << x = i * @delta
      @values[x] = func.call(x)
      @next_value[x] = (i + 1) * delta
    end
  end

  def evaluate(x)
    if @values.key? x
      return @values[x]
    elsif @range.include? x
      rangeidx = locate_range(@keys_arr, x)
      xa = @keys_arr[rangeidx]
      ya = @values[xa]
      xb = @keys_arr[rangeidx + 1]
      yb = @values[xb]
      lerp(xa, ya, xb, yb, x)
    else
      nil
    end
  end

  def invert
    new_values 
  end
end

func = Proc.new do |x|
  x * x
end

f = Functionoid.new(func, 0..1, 10)
p f
100.times do |i|
  x = 0.01
  puts "#{x},#{f.evaluate(x)}"
end
