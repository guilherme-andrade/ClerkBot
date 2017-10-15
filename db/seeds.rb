# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Intent.destroy_all

home = Intent.new(
  tag: "",
  message: "Hi there, what would you like to do?",
  reference: "home",
  content_type: "",
  title: "",
  option_types: "quick replies",
  subtitle: "",
  image: "",
  url: "",
)
home.save

promo_code = Intent.new(
  tag: "",
  message: "This is the message sent after promo code",
  reference: "promo_code",
  content_type: "",
  title: "Use my promo code",
  option_types: "none",
  subtitle: "",
  image: "",
  url: "",
)

promo_code.parent_intent = home
promo_code.save

home.child_intents.create(
  tag: "",
  message: "This is the message sent when you ask for help",
  reference: "help",
  content_type: "",
  title: "Ask a person for help",
  option_types: "none",
  subtitle: "",
  image: "",
  )
