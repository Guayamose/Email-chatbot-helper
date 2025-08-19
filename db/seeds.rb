# create a seed to create fake chats with fake messages
# this is for testing purposes only
Message.destroy_all
Chat.destroy_all
Politeness.destroy_all
User.destroy_all
politeness = Politeness.create(level: "polite")
# create 10 fake chats with fake messages
puts "created"
user = User.create!(
  email: "michael123@gmail.com",
  password: "123456",
  password_confirmation: "123456"
)
  10.times do
    puts "creating chat"
    chat = user.chats.create(title: Faker::Lorem.sentence, receiver: "coworker", subject: "new hire", politeness: politeness)
    10.times do
      puts "creating message"
      chat.messages.create(content: Faker::Lorem.paragraph, who_sent: Faker::Name.name)
    end
  end
puts "finished  "
