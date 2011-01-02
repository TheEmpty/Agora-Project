require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  setup do
    @person = people(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
  end

  test "should search people" do
    # DEPENDENT: on fixture with first_name: Mohammad last_name: El-Abid
    get :index, :first_name => "mohAMmad", :last_name => "ab"
    assert_response :success
    # test that @people >= 1, incase other people match this
    assert assigns[:people].count >= 1
    # but make sure that John Doe doesn't show up (fixture ID two)
    assert !assigns[:people].include?(people(:two))
  end

  test "should order people" do
    get :index, :sort => "id", :direction => "desc"
    assert_response :success
    assert assigns[:people][0].id == Person.last.id
  end

  test "should search ordered people" do
    # DEPENDENT: on fixture with first_name: Mohammad last_name: El-Abid being lowest ID number
    get :index, :sort => "id", :direction => "asc", :first_name => "mohammad"
    assert_response :success
    # Should return Mohammad El-Abid within the first result as it's sort by ID (ID of Mohammad should be the lowest)
    assert assigns[:people][0].first_name = "Mohammad"
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person" do
    assert_difference('Person.count') do
      post :create, :person => {:first_name => "John", :last_name => "Doe", :address => "123", :email => "test@test.com"}
    end

    assert_redirected_to person_path(assigns(:person))
  end

  test "should show person" do
    get :show, :id => @person.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @person.to_param
    assert_response :success
  end

  test "should update person" do
    put :update, :id => @person.to_param, :person => @person.attributes
    assert_redirected_to person_path(assigns(:person))
  end

  test "should destroy person" do
    assert_difference('Person.count', -1) do
      delete :destroy, :id => @person.to_param
    end

    assert_redirected_to people_path
  end
end
