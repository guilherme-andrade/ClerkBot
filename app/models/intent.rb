class Intent < ApplicationRecord
  belongs_to :parent_intent, class_name: 'Intent', foreign_key: "intent_id", optional: true
  has_many :child_intents, class_name: 'Intent', foreign_key: "intent_id", dependent: :nullify

  validates_presence_of :payload, :on => :create, :message => "payload missing! without a key, this intent won't be referenced to any point in thee conversation tree!"
  validates_uniqueness_of :payload, :on => :create, :message => "There is already a payload with %s value in the DB", scope: :parent_intent

  validates_presence_of :payload_type, :on => :create, :message => "payload type missing! without type, the bot won't know how to show your message to the user!"
  validates_inclusion_of :payload_type, :in => %w( quick_reply button template none web_url postback ), :on => :create, :message => "payload type %s is not included in the list"

  validates_presence_of :url, :on => :create, :message => "can't be blank", if: { self.payload_type == "template" }
    # the intent needs to be turned into a message where the text or attachment printed
    # comes from the parent, and the options given come from the children.

  def prepare_message
   case self.payload_type
    when "quick reply"
      intent.to_message_with_quick_replies
    when "button"
      intent.to_message_with_buttons
    when "template"
      intent.to_message_with_templates
    when "none"
      intent.to_simple_message
    end
  end

# 1st option: creating a message giving quick replies to child intents

  def to_message_with_quick_replies
    {
      text: self.message,
      quick_replies: self.get_quick_replies
    }
  end


  def get_quick_replies
    self.child_intents.map do |intent|
      {
        content_type: 'text',
        title: self.title,
        payload: self.payload
      }
    end
  end


# 2nd option: creating a message giving buttons to child intents

  def to_message_with_buttons
    {
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: self.message,
          buttons: self.get_buttons
        }
      }
    }
  end


  def get_buttons
    self.child_intents.map do |intent|
      {
        type: 'postback',
        title: self.title,
        payload: self.payload,
        url: self.url
      }
    end
  end


# 3rd option: creating a message giving templates with one card for each sub-parent

  def to_message_with_templates
    {
      attachment:{
        type: self.payload_type,
        payload: {
          template_type: "generic",
          elements: self.get_templates
        }
      }
    }
  end


  def get_templates
    self.child_intents.map do |intent|
      {
        title: intent.title,
        image_url: intent.message,
        subtitle: intent.subtitle,
        default_action: {
          type: intent.payload_type,
          url: intent.image,
          messenger_extensions: true,
          webview_height_ratio: "tall",
          fallback_url: intent.url
        },
        buttons: intent.get_buttons
      }
    ]
  end


# 4th option: creating a message with text only

  def to_simple_message
    {
      text: self.message
    }
  end
end
