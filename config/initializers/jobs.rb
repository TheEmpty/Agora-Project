class VerifyPersonJob < Struct.new(:person_id)
  def perform
    person = Person.find person_id
    person.update_attribute "activated", true
  end
end