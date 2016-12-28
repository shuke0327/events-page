class Comment < ApplicationRecord
  belongs_to :commentable
  belongs_to :creator, class_name: "User"
  # author: zchar
  validates :content,
          presence: { message: "没有输入内容哦" },
          length: { maximum: 20000,
                    too_long: "内容最多支持 5000 字，太长了保存不了哦" }

end
