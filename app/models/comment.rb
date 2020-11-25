# == Schema Information
#
# Table name: comments
#
#  id           :integer          not null, primary key
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  commenter_id :integer
#  song_id      :string
#
class Comment < ApplicationRecord

  #Validations
  validates(:song_id, { :presence => true })
  validates(:commenter_id, { :presence => true })
  validates(:body, { :presence => true })

  #Direct Associations
  belongs_to(:commenter, { :required => false, :class_name => "User", :foreign_key => "commenter_id" })


end
