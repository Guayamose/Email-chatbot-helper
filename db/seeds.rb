
# this is for testing purposes only
if Rails.env.development?
  puts "Deleting database"
  Message.destroy_all
  Chat.destroy_all
  Politeness.destroy_all
  User.destroy_all

casual = Politeness.find_or_create_by(level: 'Casual')
Politeness.find_or_create_by(level: 'Polite')
Politeness.find_or_create_by(level: 'Formal')

  # create 10 fake chats with fake messages
  puts "created"
  user = User.create!(
    email: "michael123@gmail.com",
    password: "123456",
    password_confirmation: "123456"
  )
  10.times do
    puts "creating chat"
    chat = user.chats.create(title: Faker::Lorem.sentence, receiver: "coworker", subject: "new hire", politeness: casual)
    10.times do
      puts "creating message"
      chat.messages.create(content: Faker::Lorem.paragraph, who_sent: Faker::Name.name)
    end
  end
  puts "finished creating test users, chats, and messages"
end

Politeness.find_or_create_by(level: 'Casual')
Politeness.find_or_create_by(level: 'Polite')
Politeness.find_or_create_by(level: 'Formal')
