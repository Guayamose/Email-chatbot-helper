# create a seed to create fake chats with fake messages
# this is for testing purposes only
politeness = Politeness.create(level: "polite")
# create 10 fake chats with fake messages
puts "created"
10.times do
  puts "creating chat"
  chat = Chat.create(title: Faker::Lorem.sentence, politeness: politeness)
  10.times do
    puts "creating message"
    Message.create(content: Faker::Lorem.paragraph, who_sent: Faker::Name.name)
  end
end
puts "finished  "
