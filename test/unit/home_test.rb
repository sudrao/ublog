require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  # Create normal
  def test_normal_dup_create
    home = Home.new(:ublog_name => 'newname',
                    :owner => 'userid',
                    :name => 'Some Body')
    assert home.valid?, home.errors.full_messages # assert COND, MSG_ON_FAILURE
    home.save
    dup = Home.new(:ublog_name => 'newname', # duplcate ublog_name
                   :owner => 'userid1',
                   :name => 'Some Body1')
    assert !dup.valid?
    assert dup.errors.invalid?(:ublog_name)
  end
  
  def test_bad_params
    home = Home.new(:ublog_name => 'brand new',
    :owner => nil,
    :name => 'Some Body1')
    assert !home.valid?
    assert home.errors.invalid?(:ublog_name)
    assert_equal " cannot have blanks or punctuation. Remove them. Check for trailing blanks.",
                 home.errors.on(:ublog_name)
    assert home.errors.invalid?(:owner)
  end
end
