#
# teacher和student多对多关系类
#
# @author 作者名 <作者邮箱>
#
class Relation < ApplicationRecord
    belongs_to :student
    belongs_to :teacher   

end