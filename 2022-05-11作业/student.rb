#
# student类
#
# @author edgar.zhang <edgar.zhang@rccchina.com>
#
class Student < ApplicationRecord
    validates :name, :presence => true  
    validates :age, numericality: { greater_than: 0 }
    belongs_to :school
    has_many :relations
    has_many :teachers, :through => :relations
  
  
    #根据年龄age查询数据
    scope :by_age, ->(age = 18) { where(age: age)}
  
    #
    # 创建学生时, 年龄不能为负数 (观察errors)
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [string, int] name 姓名 age 年龄
    #
    def self.create_stu(name, age)
      student = Student.new(name: name, age: age)
      result = student.save
      if !result
        student.errors##<ActiveModel::Errors [#<ActiveModel::Error attribute=age, type=greater_than, options={:value=>-10, :count=>0}>]> 
      end  
    end
  end
  