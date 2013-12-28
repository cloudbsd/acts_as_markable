require 'test_helper'

class ActsAsMarkableTest < ActiveSupport::TestCase
  setup do
    3.times do |i|
      User.create(name: "user#{i+1}")
    end
    3.times do |i|
      Blog.create(title: "blog title #{i+1}")
    end
    3.times do |i|
      Post.create(title: "post title #{i+1}")
    end
  end

  test "module 'ActsAsMarkable' is existed" do
    assert_kind_of Module, ActsAsMarkable
  end

  test "acts_as_marker method is available" do
    assert User.respond_to? :acts_as_marker
    assert User.respond_to? :acts_as_marker_on
  end

  test "acts_as_markable method is available" do
    assert Blog.respond_to? :acts_as_markable
    assert Blog.respond_to? :acts_as_markable_by
    assert Post.respond_to? :acts_as_markable
    assert Post.respond_to? :acts_as_markable_by
  end

  test "mark?/mark/unmark methods are available" do
    user = User.first
    assert user.respond_to? :mark?
    assert user.respond_to? :mark
    assert user.respond_to? :unmark
  end

  test "method 'acts_as_marker' is available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal(false, user1.mark?(post1, 'favorite'))
    user1.mark(post1, 'favorite')
    assert_equal(true, user1.mark?(post1, 'favorite'))
    assert_equal 1, ActsAsMarkable::Mark.all.count
    assert_equal 1, user1.marks.count

    user1.mark(post2, 'favorite')
    assert_equal(true, user1.mark?(post2, 'favorite'))
    assert_equal 2, user1.marks.count

    user1.mark(post2, 'read')
    assert(user1.mark?(post2, 'read'))
    assert_equal 3, user1.marks.count
    assert_equal 2, user1.marks.where(action: 'favorite').count
    assert_equal 1, user1.marks.where(action: 'read').count

    user1.unmark(post2, 'read')
    assert(!user1.mark?(post2, 'read'))
    assert_equal 2, user1.marks.count

    user1.unmark(post2, 'favorite')
    assert_equal(false, user1.mark?(post2, 'favorite'))
    assert_equal 1, user1.marks.count

    user1.unmark(post1, 'favorite')
    assert_equal(false, user1.mark?(post1, 'favorite'))
    assert_equal 0, user1.marks.count
  end

  test "method 'acts_as_marker_on' is available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, user1.favorite_posts_marks.count
    assert_equal 0, user1.favorite_posts.count
    user1.mark(post1, 'favorite')
    assert_equal 1, user1.marks.where(action: 'favorite').size
    assert_equal 1, user1.favorite_posts_marks.count
    assert_equal 1, user1.favorite_posts.count

    assert_equal 0, user1.read_posts_marks.count
    assert_equal 0, user1.read_posts.count
    user1.mark(post1, 'read')
    assert_equal 1, user1.marks.where(action: 'read').size
    assert_equal 1, user1.read_posts_marks.count
    assert_equal 1, user1.read_posts.count

    assert_equal 2, user1.marks.size
  end

  test "method 'acts_as_markable_by' is available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, post1.favorite_users_marks.count
    assert_equal 0, post1.favorite_users.count
    user1.mark(post1, 'favorite')
    assert_equal 1, post1.marks.where(action: 'favorite').size
    assert_equal 1, post1.favorite_users_marks.count
    assert_equal 1, post1.favorite_users.count

    assert_equal 0, post1.read_users_marks.count
    assert_equal 0, post1.read_users.count
    user1.mark(post1, 'read')
    assert_equal 1, post1.marks.where(action: 'read').size
    assert_equal 1, post1.read_users_marks.count
    assert_equal 1, post1.read_users.count

    assert_equal 2, post1.marks.size
  end

  test "generated methods by 'acts_as_marker_on' are available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, user1.favorite_posts_marks.count
    assert_equal 0, user1.favorite_posts.count

    assert_equal false, user1.favorite?(post1)
    user1.favorite(post1)
    assert_equal true, user1.favorite?(post1)

    user1.favorite(post2)
    assert_equal 2, user1.marks.where(action: 'favorite').size
    assert_equal 2, user1.favorite_posts_marks.count
    assert_equal 2, user1.favorite_posts.count

    user1.unfavorite(post2)
    assert_equal 1, user1.marks.where(action: 'favorite').size
    assert_equal 1, user1.favorite_posts_marks.count
    assert_equal 1, user1.favorite_posts.count

    assert_equal 0, user1.read_posts_marks.count
    assert_equal 0, user1.read_posts.count

    user1.read(post1)
    assert_equal 1, user1.marks.where(action: 'read').size
    assert_equal 1, user1.read_posts_marks.count
    assert_equal 1, user1.read_posts.count

    assert_equal 2, user1.marks.size
  end

  test "generated methods 'acts_as_markable_by' are available" do
    user1, user2 = User.all[0], User.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, post1.favorite_users_marks.count
    assert_equal 0, post1.favorite_users.count

    assert_equal false, post1.favorite_by?(user1)
    post1.favorite_by user1
    assert_equal true, post1.favorite_by?(user1)

    assert_equal 1, post1.marks.where(action: 'favorite').size
    assert_equal 1, post1.favorite_users_marks.count
    assert_equal 1, post1.favorite_users.count

    post1.unfavorite_by user1
    assert_equal false, post1.favorite_by?(user1)

    assert_equal 0, post1.read_users_marks.count
    assert_equal 0, post1.read_users.count
    user1.mark(post1, 'read')
    assert_equal 1, post1.marks.where(action: 'read').size
    assert_equal 1, post1.read_users_marks.count
    assert_equal 1, post1.read_users.count

    assert_equal 1, post1.marks.size
  end

  test "using same action for blog and post works" do
    user1, user2 = User.all[0], User.all[1];
    blog1, blog2 = Blog.all[0], Blog.all[1];
    post1, post2 = Post.all[0], Post.all[1];

    assert_equal 0, user1.favorite_posts_marks.count
    assert_equal 0, user1.favorite_posts.count

    assert_equal false, user1.favorite?(blog1)
    assert_equal false, user1.favorite?(post1)
    user1.favorite(blog1)
    user1.favorite(post1)
    assert_equal true, user1.favorite?(blog1)
    assert_equal true, user1.favorite?(post1)

    assert_equal 2, user1.marks.size
    assert_equal 2, user1.marks.where(action: 'favorite').size
    assert_equal 2, user1.favorite_marks.count
    assert_equal 1, user1.favorite_blogs_marks.count
    assert_equal 1, user1.favorite_blogs.count
    assert_equal 1, user1.favorite_posts_marks.count
    assert_equal 1, user1.favorite_posts.count
  end
end
