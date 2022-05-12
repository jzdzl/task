#
# 雇员类
#
# @author edgar.zhang <edgar.zhang@rccchina.com>
#
class Employee < ApplicationRecord

    belongs_to :parent, class_name: 'Employee', foreign_key: 'fid' 
    has_many :children, class_name: 'Employee', foreign_key: 'fid' 
 
    #
    # 写出一个查询语句id为[10,11,12]人员的上级的所有下级
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [array] ids id数组
    #
    # @return [array] employee人员数组
    #
    def self.child(ids)
      emp = Employee.where(id: ids)
      arr = []
      emp.each do |emp|
        arr << emp.parent.children
      end
      arr
    end

    #
    # 优化上一个方法的查询，通过一条语句查询出结果,避免n+1
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [array] ids id数组
    #
    # @return [array] employee人员数组
    #
    def self.childs(ids)
      emp = Employee.eager_load(:parent).eager_load(:children).where(id: ids)
      arr = []
      emp.each do |emp|
        arr << emp.parent.children
      end
      arr
    end

    #
    # 查询某个人的所有上级，一直到最顶端
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [int] id 雇员id
    #
    # @return [array] employee雇员上级列表
    #
    def self.parent(id)
      emp = Employee.where(id: id)
      arr = []
      emp.each do |emp|
        if emp.parent
            arr << emp.parent
            info = self.parent(emp.parent.id)
            if info.length != 0
                info.each do |item|#加一层迭代，否则数组格式不对
                    arr << item
                end                  
            end          
        end               
      end
      arr
    end

  end
  