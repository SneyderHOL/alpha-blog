require "test_helper"

class UsersSignUpTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username: "johndoe", email: "johndoe@example.com",
                        password: "password")
  end

  test "get user signup form and create user" do
    get signup_path
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: "johny", 
                                         email: "johny@example.com",
                                         password: "password" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "you have signed up", response.body
    assert_select "div.alert-success"
  end

  test "get user signup form and reject invalid user submission empty username" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: " ", 
                                         email: "johny@example.com",
                                         password: "password" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get user signup form and reject invalid user submission empty email" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "johny", 
                                         email: "",
                                         password: "password" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get user signup form and reject invalid user submission empty password" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "johny", 
                                         email: "johny@example.com",
                                         password: "" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get user signup form and reject invalid user submission repeated username" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "johndoe", 
                                         email: "johny@example.com",
                                         password: "password" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get user signup form and reject invalid user submission repeated email" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "johny", 
                                         email: "johndoe@example.com",
                                         password: "password" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get user signup form and reject invalid user submission incorrect email format" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "johny", 
                                         email: "johny.at.example",
                                         password: "password" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get user signup form and reject invalid user submission too long email" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "johny", 
                                         email: "a" * 100  + "johny@example.com",
                                         password: "password" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get user signup form and reject invalid user submission too short username" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "ny", 
                                         email: "johny@example.com",
                                         password: "password" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get user signup form and reject invalid user submission too long username" do
    get signup_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "a" * 22 + "johny", 
                                         email: "johny@example.com",
                                         password: "password" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end
end
