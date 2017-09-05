module Util
  module_function
  def get_payload(message)
    if message.messaging["message"] && message.messaging["message"]["quick_reply"]
      return message.messaging["message"]["quick_reply"]["payload"]
    else
      return nil
    end
  end

  def get_intent(message, payload = nil)
    payload = get_payload(message) if !payload
    if payload
      intent = Intent.where("q_key = ?", payload).first
      intent = Intent.first if !intent
    else
      intent = Intent.first
    end
    intent
  end

end
