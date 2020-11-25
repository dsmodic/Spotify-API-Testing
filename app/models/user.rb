# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  email                          :string
#  first_name                     :string
#  last_name                      :string
#  password_digest                :string
#  received_follow_requests_count :integer
#  sent_follow_requests_count     :integer
#  user_name                      :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password

  #Validations
  validates(:user_name, { :presence => true })
  validates(:user_name, { :uniqueness => true })
  validates(:last_name, { :presence => true })
  validates(:first_name, { :presence => true })

  #Direct Associations
  has_many(:likes, { :class_name => "Like", :foreign_key => "user_id", :dependent => :destroy })
  has_many(:received_follow_requests, { :class_name => "FollowRequest", :foreign_key => "recipient_id", :dependent => :destroy })
  has_many(:sent_follow_requests, { :class_name => "FollowRequest", :foreign_key => "sender_id", :dependent => :destroy })
  has_many(:comments, { :class_name => "Comment", :foreign_key => "commenter_id", :dependent => :destroy })

  #Indirect Associations
  has_many(:follows, { :through => :sent_follow_requests, :source => :recipient })
  has_many(:followers, { :through => :received_follow_requests, :source => :sender })



end
