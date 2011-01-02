class Person < ActiveRecord::Base
  validates :first_name, :presence => true
  validates :last_name,  :presence => true
  validates :address,    :presence => true
  validates :email,      :presence => true, :format => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  # make sure the email is unique if they are changing their email or if they are creating a new Person.
  validates :email,      :uniqueness => true, :on => :new
  validates :email,      :uniqueness => true, :if => Proc.new {|p|p.changed_attributes.has_key?("email")}

  after_create :delayed_validation_job

  def delayed_validation_job
    Delayed::Job.enqueue VerifyPersonJob.new(self[:id])
  end

  def pretty_phonenumber
    self[:phonenumber].blank? ? "N/A" : self[:phonenumber]
  end

end
