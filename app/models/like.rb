# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  song_id    :string
#  user_id    :integer
#
class Like < ApplicationRecord

  #Validations
  validates(:user_id, { :presence => true })
  validates(:song_id, { :presence => true })
  validates(:song_id, { :uniqueness => { :scope => ["user_id"], :message => "already liked" } })
  
  #Direct Associations
  belongs_to(:user, { :required => false, :class_name => "User", :foreign_key => "user_id" })


end
