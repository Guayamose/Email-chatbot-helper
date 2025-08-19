# create a seed to create fake chats with fake messages
# this is for testing purposes only

# create 10 fake chats with fake messages
10.times do
  chat = Chat.create(title: Faker::Lorem.sentence, politeness_level: 'nice')
  10.times do
    Message.create(chat: chat, content: Faker::Lorem.paragraph, who_sent: Faker::Name.name)
  end
end
