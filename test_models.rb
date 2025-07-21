puts "Testing Habit and HabitCheckin Models..."

# Test Habit Validations
puts "\n1. Testing Habit Validations:"

# Test invalid habit (should fail)
habit = Habit.new
if !habit.valid?
  puts "✅ Empty habit validation working"
  puts "Errors: #{habit.errors.full_messages}"
else
  puts "❌ Empty habit validation failed"
end

# Test valid habit
habit = Habit.new(
  title: "Read Books",
  description: "Read for 30 minutes daily",
  frequency: 1,
  user: User.first
)
if habit.valid?
  puts "✅ Valid habit passes validation"
else
  puts "❌ Valid habit validation failed"
  puts "Errors: #{habit.errors.full_messages}"
end

# Test habit with invalid frequency
habit.frequency = 0
if !habit.valid?
  puts "✅ Invalid frequency validation working"
  puts "Errors: #{habit.errors.full_messages}"
else
  puts "❌ Invalid frequency validation failed"
end

# Save a valid habit for testing HabitCheckin
habit.frequency = 1
habit.save!
puts "✅ Saved test habit"

puts "\n2. Testing Habit Scopes:"
puts "Active habits count: #{Habit.active.count}"
puts "Today's completed habits: #{Habit.completed_today.count}"
puts "Today's pending habits: #{Habit.pending_today.count}"

puts "\n3. Testing HabitCheckin Validations:"

# Test future date (should fail)
checkin = habit.habit_checkins.build(checked_on: Date.tomorrow)
if !checkin.valid?
  puts "✅ Future date validation working"
  puts "Errors: #{checkin.errors.full_messages}"
else
  puts "❌ Future date validation failed"
end

# Test valid date (should pass)
checkin.checked_on = Date.current
if checkin.valid?
  puts "✅ Current date validation working"
else
  puts "❌ Current date validation failed"
  puts "Errors: #{checkin.errors.full_messages}"
end

# Test duplicate date (should fail)
checkin.save!
duplicate_checkin = habit.habit_checkins.build(checked_on: Date.current)
if !duplicate_checkin.valid?
  puts "✅ Duplicate date validation working"
  puts "Errors: #{duplicate_checkin.errors.full_messages}"
else
  puts "❌ Duplicate date validation failed"
end

puts "\n4. Testing HabitCheckin Scopes:"
puts "Today's checkins: #{HabitCheckin.today.count}"
puts "Past week checkins: #{HabitCheckin.past_week.count}"
puts "Past month checkins: #{HabitCheckin.past_month.count}"

puts "\n5. Testing Habit Helper Methods:"
puts "Current streak: #{habit.current_streak}"
puts "Completion rate: #{habit.completion_rate}%"
puts "Completed today?: #{habit.completed_today?}"
