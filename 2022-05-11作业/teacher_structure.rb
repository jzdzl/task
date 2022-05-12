#
# 老师结构类
#
# @author edgar.zhang <edgar.zhang@rccchina.com>
#
class TeacherStructure < ApplicationRecord
    # super_id和teacher_id一对多的关系
    self.primary_key = "teacher_id"
    belongs_to :parent, class_name: 'TeacherStructure', foreign_key: 'super_id'
    has_many :children, class_name: 'TeacherStructure', foreign_key: 'super_id'
  
    #
    # 根据teacher_id，查询出其上级
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [int] teacher_id 老师id
    #
    # @return [array] 数组
    #
    def self.parent(teacher_id)
      TeacherStructure.find_by(teacher_id: teacher_id).parent
    end
  
    #
    # 根据teacher_id，查询出其下级
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [int] teacher_id 老师id
    #
    # @return [array] 数组
    #
    def self.child(teacher_id)
      TeacherStructure.find_by(teacher_id: teacher_id).children
    end
  end