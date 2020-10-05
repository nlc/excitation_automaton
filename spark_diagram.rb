require_relative 'automaton.rb'

uniform =
Proc.new do |min_radius, max_radius|
  rand * (max_radius - min_radius) + min_radius
end

uniform_outer_half =
Proc.new do |min_radius, max_radius|
  min_radius = (min_radius + max_radius) / 2.0
  rand * (max_radius - min_radius) + min_radius
end

first_quarter =
Proc.new do |num_points, i|
  if i <= num_points / 4
    :excited
  else
    :resting
  end
end

all_resting =
Proc.new do |num_points, i|
  :resting
end

# initialize(max_radius, num_points, probability, state_gen, cooldown, nbr_radius, threshold)
cooldown = 3
automaton = Automaton.new(1.0, 3000, uniform_outer_half, all_resting, cooldown, 0.1, 4)

# aftermarket pizza slice
automaton.points.each do |point, state_and_timer|
  r, theta = point
  state, timer = state_and_timer

  if theta >= 0 && theta <= Math::PI / 4.0
    automaton.points[point] = [:excited, timer]
  elsif theta > Math::PI / 4.0 && theta <= Math::PI / 2.0 # force it to spin cw
    automaton.points[point] = [:refractory, cooldown]
  end
end

# # aftermarket bullseye
# automaton.points.each do |point, state_and_timer|
#   r, theta = point
#   state, timer = state_and_timer
# 
#   if r <= 0.05
#     automaton.points[point] = [:excited, timer]
#   end
# end

# approximately cubic?
puts 'frame,x,y'
automaton.points.each do |point, state_and_timer|
  state, timer = state_and_timer
  if state == :excited
    puts "0,#{automaton.to_cartesian[point].join(',')}"
  end
end
250.times do |frame|
  break if automaton.transition == 0
  automaton.points.each do |point, state_and_timer|
    state, timer = state_and_timer
    if state == :excited
      puts "#{frame + 1},#{automaton.to_cartesian[point].join(',')}"
    end
  end
end
