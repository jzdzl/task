#
# 学校类
#
# @author edgar.zhang <edgar.zhang@rccchina.com>
#
class School < ApplicationRecord
    has_many :students
end
