require 'json'
require "facebook/messenger"

class Brain
  include Facebook::Messenger

  # PersistentMenu.enable

  # Greetings.enable
# =============================================================================================================================
#                                          - RESPONSE SELECTION ARCHITECTURE -
#
#    to be used as pseudo code for app/bot/listen.rb, methods will be defined in a Brain/ Module Class app/bot/brain.rb
# =============================================================================================================================
  def initialize(message)
    @message = message
    @user = message.sender
    if message.is_a? Facebook::Messenger::Incoming::Postback
      @payload = message.payload
    else
      @text =  message.text
      @payload = message.quick_reply
    end
  end
#
#
# 1. INTENT CLASSIFICATION - Intents are actions(verbs) that the user wants the bot to perform
  def classify_intent
#
#    1.1 Get the intent from message
    @intent = Intent.find_by(reference: @payload)
#
#
#    1.2 Relate it to Context (the context should be of a likely user story to happen) (contextualize)
    context = contextualize
#
#
#
#
#       [ACTION REQUIRED] - needs the Context and Intent models to be defined ASAP, since they will be used in all steps
  end
#
# -----------------------------------------------------------------------------------------------------------------------------
#
# 2. ENTITY RECOGNITION - Entities are descriptive (adverbs - how, when, where, why, how much) of the action to be performed
  def identify_entities
#
#    2.1 Get the entities from User message using Natural Language Processing (facebook + Wit.ai) (get_entities(message))
    entities = get_entities(@message)
#
#       * Entities are what Wit.ai can help us get.
#
#
#       [QUESTION TO RESEARCH] Can wit.ai use context and intent to get better entities ?
#
#       [TO CONFIRM] Should we use an Entity model that looks like facebook's messenger responses?
    return entities
  end
#
# -----------------------------------------------------------------------------------------------------------------------------
#
# 3. GET RESPONSE CANDIDATES
  def get_response_candidates
#
#    3.1 Relate with Context again (contextualize)
    context = contextualize
#
#    3.2 Read Intent (intent = {})
    intent = classify_intent
#
#
#    3.3 Read Entities (entities = {})
    entities = identify_entities
#
#    3.4 Search through of answers (search_answers(context, intent = {}, entities = {})).
    answers = search_answers(context, intent = "", entities = {})
#
#
#       * Relate the context with entities and intents to figure out how to query the replies table in DB
    return answers
  end
#
#
# -----------------------------------------------------------------------------------------------------------------------------
#
# 4. SELECT ANSWER
  def select_answer
#
    if @payload
#   4.1 If @message is a message => when user clicks an option
#
      classify_intent
#
#     4.1.1 Get the answer linked to intent
      answer = @intent.prepare_message
#
      return answer
#
#
    else
#   4.2 If @message is a message
#
#     4.2.1 Read Context again (contextualize)
      context = contextualize
#
#
#     4.2.2 Get the candidates
      candidates = get_response_candidates
#
#
#     4.2.3 Check which candidate is better for context
      answer = check_which_answer_is_adequate(candidates, context)
#
#        * Send reply to user if one response has certainty < 80 %
#
#       * If not, send all possible responses to user (in order of certainty), asking which he wants to do.
#
#
      return answer
    end
  end
#
# -----------------------------------------------------------------------------------------------------------------------------
#
  private
#
#
#
  def get_intent
#    checks if message matches any intent's tags with a high certainty ratio
#    asks which option is best if not sure and gives option to talk to a real person
  end
#
#
#
  def get_entities(message)
#    checks with wit.ai what entities are present in the message, like location, etc.
#
  end
#
#
#
  def contextualize
#    store payload in context if it exists
#    search in the logs what was the previous context of message
  end
#
#
#
  def search_answers(context, intent = "", entities = {})
#
#
  end
#
#
#
  def check_which_answer_is_adequate(candidates, context)
#
#
  end
end
# =============================================================================================================================




# class Brain

#   attr_reader :message, :postback, :payload
#   attr_reader :sender, :text, :attachments


#   # message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
#   # message.sender      # => { 'id' => '1008372609250235' }
#   # message.seq         # => 73
#   # message.sent_at     # => 2016-04-22 21:30:36 +0200
#   # message.text        # => 'Hello, bot!'
#   # message.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]

#   def self.set_message(message)
#     # Method that processes a received message

#     # sets message to what receives in the arguments
#     @message     = message

#     # sets sender to message sender
#     @sender      = message.sender

#     # sets text to message text
#     @text        = message.text

#     # sets attachments to message attachments
#     @attachments = message.attachments
#   end

#   def self.set_postback(postback)
#     # Method that sets the postback

#     # sets the postback as received in arguments
#     @postback = postback

#     # sets the payload to the postback payload
#     @payload  = postback.payload

#     # sets the sender to postback sender
#     @sender   = postback.sender
#   end

#   def self.start_typing
#     # make the bot start typing
#     Facebook::Client.new.set_typing_on(sender["id"])
#   end

#   def self.stop_typing
#     # make the bot stop typing
#     Facebook::Client.new.set_typing_off(sender["id"])
#   end

#   def self.process_message
#     if message.messaging["message"]["quick_reply"].present?
#       @payload = message.messaging["message"]["quick_reply"]["payload"]
#       process_postback
#     elsif text.present? && user.prev_intent && user.prev_intent.is_pipeline
#       process_pipeline
#     elsif text.present?
#       process_text
#     else
#       send_error
#     end
#   end

#   def self.process_pipeline
#     if user.prev_intent.process_data(data: text, user: user)
#       @intent = user.prev_intent.child_intents.first
#       user.prev_intent = @intent
#       user.save
#       send_messages
#     else
#       send_pipeline_error
#     end
#   end

#   def self.process_postback
#     if user.prev_intent && user.prev_intent.is_pipeline
#       user.prev_intent.process_data(data: payload, user: user)
#     end
#     @intent = Intent.find_by(q_key: payload) || Intent.first
#     user.prev_intent = @intent
#     user.save
#     send_messages
#   end



#   def self.create_log
#     if message.present?
#       Log.create(
#         user_id:       user.id,
#         fb_message_id: message.id,
#         message_type:  message_type,
#         sent_at:       message.sent_at
#       )
#     else
#       Log.create(
#         user_id:      user.id,
#         message_type: "postback",
#         sent_at:      postback.sent_at
#       )
#     end
#   end


#   private

#   def self.process_text
#     @intent = user.prev_intent
#     words = text.split
#     posible_intents = []
#     sub_intents = []
#     words.each do |word|
#       if word.length > 2
#         res = Intent.where(searchable: true).search(word)
#         sub_res = Intent.where(searchable: true).search_sub(word)
#         posible_intents += res
#         sub_intents += sub_res
#       end
#     end
#     frequency = Hash.new(0)
#     posible_intents.each do |intent|
#       frequency[intent] += 1
#       if sub_intents.include? intent
#         frequency[intent] += 1
#       end
#     end
#     intents_whit_rank = frequency.sort_by{|intent, f| -f}
#     if posible_intents.length == 0 || posible_intents.length > 3
#       send_error
#     elsif posible_intents.length == 1
#       @intent = posible_intents.first
#       send_messages
#     elsif intents_whit_rank[0][1] < intents_whit_rank[1][1]
#       @intent = intents_whit_rank[0][0]
#       send_messages
#     else
#       intents = intents_whit_rank.map{ |e| e.first}
#       send_did_u_mean(intents)
#     end
#   end

#   def self.send_messages
#     messages_out = @intent.answer.to_messages(user)
#     messages_out.each do |message_out|
#       Bot.deliver({
#         recipient: sender,
#         message: message_out
#       })
#     end
#   end

#   def self.send_pipeline_error
#     Bot.deliver(
#       recipient: sender,
#       message: {
#         text: "Sorry, didn't understand that.",
#         quick_replies: [{
#             content_type: 'text',
#             title: "Exit",
#             payload: 'root'
#         }]
#       }
#     )
#   end

#   def self.send_did_u_mean(intents)
#     quick_replies = intents.map do |n|
#         {
#             content_type: 'text',
#             title: n.q_string,
#             payload: n.q_key
#         }
#     end
#     quick_replies << {
#             content_type: 'text',
#             title: "Back to start",
#             payload: 'root'
#         }
#     Bot.deliver(
#       recipient: sender,
#       message: {
#         text: "Sorry, didn't quit understand that. Did you mean?",
#         quick_replies: quick_replies
#       }
#     )
#   end

#   def self.send_error
#     Bot.deliver(
#       recipient: sender,
#       message: {
#         text: "Sorry, didn't understand that. Try to refrase your question",
#         quick_replies: [{
#             content_type: 'text',
#             title: "Back to start",
#             payload: 'root'
#         }]
#       }
#     )
#   end

#   def self.message_type
#     text.present? ? "text" : attachments.first["type"]
#   end

#   def user
#     @user ||= set_user
#   end

#   def set_user
#     @user = FbUser.find_by(fb_id: sender["id"])

#     if @user.nil?
#       fb_user = Facebook::Client.new.get_user(sender["id"]).symbolize_keys
#       fb_user[:fb_id] = sender["id"]
#       @user = FbUser.create!( fb_user )
#     end

#     @user
#   end
# end




