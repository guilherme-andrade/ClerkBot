# =============================================================================================================================
#                                            - RESPONSE SELECTION ARCHITECTURE -
#
#      to be used as pseudo code for app/bot/listen.rb, methods will be defined in a Brain/ Module Class app/bot/brain.rb
# =============================================================================================================================
#
#   1. INTENT CLASSIFICATION - Intents are actions(verbs) that the user wants the bot to perform
#
#      1.1 Read User Message (read_user_message)
#
#      1.2 Relate it to Context (the context should be of a likely user story to happen) (contextualize)
#
#
#         * This means we will have to store messages to generate context.
#
#
#         [ACTION REQUIRED] - needs the Context and Intent models to be defined ASAP, since they will be used in all steps
#
# -----------------------------------------------------------------------------------------------------------------------------
#
#   2. ENTITY RECOGNITION - Entities are descriptive (adverbs - how, when, where, why, how much) of the action to be performed
#
#      2.1 Get the entities from User message using Natural Language Processing (facebook + Wit.ai) (get_entities(message))
#
#
#         * Entities are what Wit.ai can help us get.
#
#
#         [QUESTION TO RESEARCH] Can wit.ai use context and intent to get better entities ?
#
#         [TO CONFIRM] Should we use an Entity model that looks like facebook's messenger responses?
#
# -----------------------------------------------------------------------------------------------------------------------------
#
#   3. GET RESPONSE CANDIDATES
#
#      3.1 Relate with Context again (contextualize)
#
#      3.2 Read Intent (intent = {})
#
#      3.3 Read Entities (entities = {})
#
#      3.4 Search through of answers (search_answers(context, intent = {}, entities = {})).
#
#
#         * Relate the context with entities and intents to figure out how to query the replies table in DB
#
#
# -----------------------------------------------------------------------------------------------------------------------------
#
#   4. SELECT RESPONSES
#
#      4.1 Read Context again (contextualize)
#
#
#         * Send reply to user if one response has certainty < 80 %
#
#         * If not, send all possible responses to user (in order of certainty), asking which he wants to do.
#
# =============================================================================================================================




require "facebook/messenger"
require "facebook/bot/util"


include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['FB_ACCESS_TOKEN'])





# Make the bot act on received message
Bot.on :message do |message|
  # puts message.text
  # puts message.sender
  # puts message.recipient
  # puts message.messaging
  # puts message.reply(text: 'Hello, human!')
  # byebug
end


# Make the bot act if user selected option
Bot.on :postback do |postback|

  # brain.rb, line: 38
  Brain.set_postback(postback)

  # brain.rb, line: 51
  Brain.start_typing

  # brain.rb, line: 96
  Brain.create_log

  # brain.rb, line: 84
  Brain.process_postback

  # brain.rb, line: 56
  Brain.stop_typing

end


# # Keep track of messages sent to user
# Bot.on :message_echo do |message_echo|
#   message_echo.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
#   message_echo.sender      # => { 'id' => '1008372609250235' }
#   message_echo.seq         # => 73
#   message_echo.sent_at     # => 2016-04-22 21:30:36 +0200
#   message_echo.text        # => 'Hello, bot!'
#   message_echo.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]
# end

# # Keep track of message requests accepted by the user
# Bot.on :message_request do |message_request|
#   message_request.accept? # => true

#   # Log or store in your storage method of choice (skynet, obviously)
# end

# # Received when user clicks on m.me links on a website
# Bot.on :optin do |optin|
#   optin.sender    # => { 'id' => '1008372609250235' }
#   optin.recipient # => { 'id' => '2015573629214912' }
#   optin.sent_at   # => 2016-04-22 21:30:36 +0200
#   optin.ref       # => 'CONTACT_SKYNET'

#   optin.reply(text: 'Ah, human!')
# end


# # Used to stalk the user
# Bot.on :delivery do |delivery|
#   delivery.ids       # => 'mid.1457764197618:41d102a3e1ae206a38'
#   delivery.sender    # => { 'id' => '1008372609250235' }
#   delivery.recipient # => { 'id' => '2015573629214912' }
#   delivery.at        # => 2016-04-22 21:30:36 +0200
#   delivery.seq       # => 37

#   puts "Human was online at #{delivery.at}"
# end


# # When a user follors an m.me, a referral can be received in the params
#   # http://m.me/mybot?ref=myparam
# Bot.on :referral do |referral|
#   referral.sender    # => { 'id' => '1008372609250235' }
#   referral.recipient # => { 'id' => '2015573629214912' }
#   referral.sent_at   # => 2016-04-22 21:30:36 +0200
#   referral.ref       # => 'MYPARAM'
# end

