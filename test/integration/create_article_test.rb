require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username:"john", email: "john@example.com", password: "password")
  end

  test "get new article form and create article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post_via_redirect articles_path, article: {title: "This is a test title", description: "I am just writing enough to make this valid"}
    end
    assert_template 'articles/show'
    assert_match "This is a test title", response.body
  end

  test "invalid articles fail" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, article: {title: "sh", description: "short"}
    end
    assert_template 'articles/new'

  end

end