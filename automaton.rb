# A model of an excitable medium
# A = < C, Q, r, h, theta, delta >
# C is a subset of R2
# each p in C has state one of Q = [ EXCITED, REFRACTORY, RESTING ]
# the neigborhood of p is u(p) = all q in C where distance(p, q) <= r
# theta is an excitation threshold, delta is refractory delay
# Transition rules:
#   RESTING -> EXCITED when num_excited(p) > threshold theta
#   EXCITED -> REFRACTORY & h = delta
#   REFRACTORY -> REFRACTORY & h--
#   REFRACTORY -> RESTING when h = 0
class Automaton
  attr_accessor :max_radius, :points, :to_cartesian, :neighbors, :cooldown, :nbr_radius, :threshold, :excited_points
  STATES = [:excited, :refractory, :resting]

  def contains?(radius, angle)
    radius < @max_radius
  end

  def assign_neighbors!
    r_squared = @nbr_radius * @nbr_radius
    @neighbors = {}

    (0...@points.length).each do |i|
      @neighbors[@points.keys[i]] = [] unless @neighbors.key? @points.keys[i]
      ((i+1)...@points.length).each do |j|
        @neighbors[@points.keys[j]] = [] unless @neighbors.key? @points.keys[j]
        cartesian_a = @to_cartesian[@points.keys[i]]
        cartesian_b = @to_cartesian[@points.keys[j]]
        # TODO should be abs
        dx = cartesian_b[0] - cartesian_a[0]
        dy = cartesian_b[1] - cartesian_a[1]

        # early bailout--optimization?
        unless dx > @nbr_radius || dy > @nbr_radius
          if dx * dx + dy * dy <= r_squared
            @neighbors[@points.keys[i]] << @points.keys[j]
            @neighbors[@points.keys[j]] << @points.keys[i]
          end
        end
      end
    end
  end

  def init_points!(probability, state_gen)
    @points = {}
    @to_cartesian = {}
    @excited_points = {}

    @num_points.times do |i|
      state = state_gen.call(@num_points, i)
      timer = nil
      if state == :refractory
        timer = @cooldown
      end

      coords_radial = [probability.call(0, @max_radius), rand * 2 * Math::PI]
      cartesian_x = coords_radial[0] * Math.cos(coords_radial[1])
      cartesian_y = coords_radial[0] * Math.sin(coords_radial[1])
      coords_cartesian = [cartesian_x, cartesian_y]

      @points[coords_radial] = [state, timer]
      @to_cartesian[coords_radial] = coords_cartesian

      if state == :excited
        @excited_points[coords_radial] = [state, timer]
      end
    end

    assign_neighbors!
  end

  def initialize(max_radius, num_points, probability, state_gen, cooldown, nbr_radius, threshold)
    @max_radius = max_radius
    @num_points = num_points
    @nbr_radius = nbr_radius
    @threshold = threshold
    @cooldown = cooldown
    init_points!(probability, state_gen)
  end

  def transition
    # RESTING -> EXCITED when num_excited(p) > threshold theta
    # EXCITED -> REFRACTORY & h = delta
    # REFRACTORY -> REFRACTORY & h--
    # REFRACTORY -> RESTING when h = 0
    next_points = {}
    num_excited = 0
    @points.each do |point, state_and_timer|
      state, timer = state_and_timer
      new_state_and_timer = state_and_timer.clone

      case state
      when :resting
        if @neighbors[point].count{|nbr| @points[nbr]&.first == :excited} >= @threshold
          num_excited += 1
          new_state_and_timer = [:excited, nil]
        end
      when :excited
        new_state_and_timer = [:refractory, @cooldown]
      when :refractory
        new_timer = timer - 1
        if new_timer <= 0
          new_state_and_timer = [:resting, nil]
        else
          new_state_and_timer = [:refractory, new_timer]
        end
      else
        raise "illegal state #{state.to_s}"
      end

      next_points[point] = new_state_and_timer
    end

    @points = next_points.clone
    num_excited
  end
end

# puts "r,num_nbrs"
# automaton.neighbors.each do |point, neighbors|
#   puts "#{point[0]},#{neighbors.length}"
# end
