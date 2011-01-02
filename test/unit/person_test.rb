require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  setup do
    # save some RAM by only creating one person and using it through out
    
    @blank_person = Person.new
    @blank_person.save

    @vague_person = Person.new(:first_name => "John",
                              :last_name => "Doe",
                              :address => "123 Woodward st., Palmpark, FL 12345",
                              :email => "john@doe.com",
                              :phonenumber => "123-123-1234")
    @vague_person.save
  end

  test "Pretty phonenumber function" do
    assert_equal "N/A", @blank_person.pretty_phonenumber, "Was expecting N/A for pretty_phonenumber. Received #{@blank_person.pretty_phonenumber}"
    assert_equal "123-123-1234", @vague_person.pretty_phonenumber, "Was expecting 123-123-1234 as the phonenumber. Received: #{@vague_person.pretty_phonenumber}"
  end
  
  # Test that it requires an email
  test "require email" do
    # invalid test
    assert_equal true, @blank_person.errors[:email].include?("can't be blank"), "Allowed person to save without email"

    # valid test
    if @vague_person.errors.has_key?(:email)
      # there is something wrong with their email, lets check to make sure it's that their email is blank
      assert_equal false, @vague_person.errors[:email].include?("can't be blank"), "Thinks @vague_persons' email is blank"
    else
      assert true, "Person had no email errors"
    end
  end

  # Test that it validates emails correctly
  test "validate emails" do
    # invalid test
    invalid = Person.new(:email => "foobar")
    invalid.save
    assert invalid.errors[:email].include?("is invalid"), "foobar was accepted as a valid email"

    # valid test
    # See if there are any errors, if there are make sure that it's not because the email is invalid
    if !@vague_person.errors[:email].blank?
      assert !@vague_person.errors.on(:email).include?("is invalid"), "#{@vague_person.email} was not accepted as a valid email"
    else
      assert true, "No errors"
    end
  end

  # Test that the email is unique
  test "require unique emails" do
    # Test creation uniqueness
    copy = Person.new(@vague_person.attributes)
    copy.save
    assert copy.errors[:email].include?("is already taken"), "Should make sure people do not have the same email"

    # Test update uniqueness
    copy = Person.new(@vague_person.attributes)
    copy.email = "bob@bob.com"
    copy.save

    copy = Person.new(@vague_person.attributes)
    copy.email = "bob@bob.com"
    copy.save

    assert copy.errors[:email].include?("is already taken"), "Should not allow people updating their email to be non-unquie"

    # Test that there is no check on uniqueness when changing an unrelated attribute
    copy = Person.new(:first_name => "test",
                      :last_name => "test",
                       :address => "test",
                       :phonenumber => '123-123-1234',
                       :email => "test@aojf.com")
    copy.save
    copy.address = '123 123'
    copy.save
    if !copy.errors[:email].blank?
      assert_equal false, copy.errors[:email].include?("is already taken"), "is checking email on save"
    else
      assert true, "No errors"
    end

  end

  # Test that it requires an address
  test "require address" do
    # invalid test
    assert @blank_person.errors[:address].include?("can't be blank"), "Allowed a person without an address"
    
    # valid test
    if !@vague_person.errors[:address].blank?
      assert !@vague_person.errors[:address].include?("can't be blank"), "Failed to allow a non-blank address field save"
    else
      assert true, "No errors"
    end
  end

  # Test that it requires a first name
  test "require first name" do
    # invalid test
    assert @blank_person.errors[:first_name].include?("can't be blank"), "Allowed a user without a first name"

    # valid test
    if !@vague_person.errors[:first_name].blank?
      assert !@blank_person.errors[:first_name].include?("can't be blank"), "Failed to allow a non-blank first_name field to save"
    else
      assert true, "No errors"
    end
  end

  # Test that it requires a last name
  test "require last name" do
    # invalid test
    assert @blank_person.errors[:last_name].include?("can't be blank"), "Allowed a user without a last name"

    # valid test
    if !@vague_person.errors[:last_name].blank?
      assert !@blank_person.errors[:last_name].include?("can't be blank"), "Failed to allow a non-blank last_name field to save"
    else
      assert true, "No errors"
    end
  end

  test "delayed job complete" do
    # run `rake jobs:work test` for this to work
    assert @vague_person.activated?, "Person was not activated, make sure you have `rake jobs:work test` running in the background"
  end

end
