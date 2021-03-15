require "test_helper"

class CreateArticleTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username: "johndoe", email: "johndoe@example.com",
                        password: "password") 
    sign_in_as(@user)
  end

  test "get new article form and create article" do
    get new_article_path
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: {
                            article: {
                              title: "My new article",
                              description: "My description for the article",
                              category_ids: []
                            }
                          }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "My new article", response.body
  end

  test "get new article form and reject invalid article with empty title" do
    get new_article_path
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: {
                            article: {
                              title: "",
                              description: "My description for the article",
                              category_ids: []
                            }
                          }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get new article form and reject invalid article too short title" do
    get new_article_path
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: {
                            article: {
                              title: "My ar",
                              description: "My description for the article",
                              category_ids: []
                            }
                          }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get new article form and reject invalid article too long title" do
    get new_article_path
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: {
                            article: {
                              title: "a" * 105,
                              description: "My description for the article",
                              category_ids: []
                            }
                          }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get new article form and reject invalid article with empty description" do
    get new_article_path
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: {
                            article: {
                              title: "My new article",
                              description: "",
                              category_ids: []
                            }
                          }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get new article form and reject invalid article too short description" do
    get new_article_path
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: {
                            article: {
                              title: "My new article",
                              description: "some",
                              category_ids: []
                            }
                          }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get new article form and reject invalid article too long description" do
    get new_article_path
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: {
                            article: {
                              title: "My new article",
                              description: "s" * 305,
                              category_ids: []
                            }
                          }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
  end

  test "get new article form as visitor user" do
    delete logout_path()
    get new_article_path
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_match "You must be logged in", response.body
    assert_select "div.alert"
  end
end
