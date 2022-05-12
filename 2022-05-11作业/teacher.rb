#
# teacher类
#
# @author edgar.zhang <edgar.zhang@rccchina.com>
#
class Teacher < ApplicationRecord
  
    has_many :relations
    has_many :students, :through => :relations, dependent: :destroy
  
    #根据年龄age查询数据
    scope :by_age, ->(age = 18) { where(age: age)}
  
    #
    # save创建老师
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [string, int, string] name 教师名 age 年龄 description 描述
    #
    # @return [boolean] true为成功false为失败
    #
    def self.save_teacher(name, age, description)
      teacher = Teacher.new(name: name, age: age, description: description)
      teacher.save
    end
  
    #
    # create创建老师
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [string, int, string] name 教师名 age 年龄 description 描述
    #
    # @return [object] 老师对象
    #
    def self.create_teacher(name, age, description)
      Teacher.create(name: name, age: age, description: description)
    end
  
    #
    # 根据id更新老师name
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [string, int, string] name 教师名 age 年龄 description 描述
    #
    # @return [boolean] true为成功false为失败
    #
    def self.update_teacher(id, name)
      info = Teacher.find_by(id: id)
      if info
        info.name = name
        info.save
      else
        return false
      end  
    end
  
    #
    # 根据id查询到该老师下年龄为18岁的学生
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [int, int] id 教师id age 想要查询的学生的年龄
    #
    # @return [array] 学生数组
    #
    def self.get_sty(id, age=18)
      Teacher.find_by(id: id).students.by_age(age)
    end
  
    #
    # 更新老师后,当老师的年龄大于60岁时，把他的学生的活跃状态改为不活跃
    #
    after_update do
      if self.age > 60
        begin
          self.students.update_all(is_active: 0)
        rescue RuntimeError => e
          raise 'error'#触发回滚
        end      
      end  
    end  
  
    #
    # 将老师的名称更新放在事务中，如果学生的状态修改失败就回滚
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [int, string] id 教师id name 教师名字
    #
    # @return [boolean] true为成功 false为失败
    #
    def self.trans_update(id, name)
      info = Teacher.find_by(id: id)
      if info
        ActiveRecord::Base.transaction do
          # 需要添加事务的逻辑代码
          info.name = name
          info.save
        end      
      else
        return false
      end  
    end
  
    #
    # 更新老师后,当老师的年龄大于60岁时，把他的学生的活跃状态改为不活跃
    #
    after_destroy do
        begin
          self.students.delete_all
        rescue RuntimeError => e
          raise 'error'#触发回滚
        end        
    end
  
    #
    # 删除一个老师，并且删除这个老师关联的学生
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [int] id 教师id
    #
    def self.del_teacher(id)
      Teacher.find_by(id: id).destroy 
    end
  
    #
    # 将select * from teachers where name = '张三' 转成rails的查询
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [object] 对象
    #
    def self.sql1(name)
      Teacher.where(name: name)
    end
  
    #
    # 将select * from teachers where name = '张三' and age = 18 转成rails的查询
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [string,int] name 教师名字 age 年龄
    #
    def self.sql2(name, age)
      Teacher.by_age(age).where(name: name)
    end
  
    #
    # 将select s.* from teachers t inner joins students s on t.id = s.teacher_id where t.name = '张三' 转成rails的查询
    # 由于设计的学生和老师是多对多的关系，所以这个改成学校和学生，这个是一对多的关系
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [string] name 名字
    #
    def self.sql3(name)
      School.joins(:students).where(name: name)
    end
  
    #
    # 查询年龄大于18岁的学生和老师的信息，并构建数据结构
    # 这里改成年龄大于18岁的学生和学校的信息（学校和学生是一对多）
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [int] age 年龄
    #
    def self.data(age=18)
      info = Student.where("age > ?", age).includes(:school)
      arr = []
      info.each do |stu|
        hash = {}
        hash['id'] = stu.id
        hash['name'] = stu.name
        hash['age'] = stu.age
        hash['school_name'] = stu.school.name
        hash['school_id'] = stu.school.id
        arr << hash
      end
      result = {}
      result['data'] = arr
      return result
    end
  
  
    
  
  
  
  
    #作业1 Teacher.first和Teacher.new的区别
    #Teacher.first是获取数据库的一条数据，返回的是一个对象,可以访问其中数据如Teacher.first.name
    #Teacher.new是初始化一个对象，没有数据
   
    #作业2 select/where/group/count/having/order/limit在ActiveRecord中顺序有没有关系
    #顺序没有关系
    #Teacher.select('name').where(id:1)和Teacher.where(id:1).select('name')结果是一样的
    
    #作业三
    #
    # 创建测试数据1
    #
    # @author edgar.zhang <edgar.zhang@rccchina.com>
    #
    # @param [int] num 创建测试数据数量
    #
    # @return [boolean] true创建结束
    #
    # def self.create_test(num)
    #   a = 0;
    #   while a < num
    #     randnum = rand(1000).to_s
    #     name = 'teacher-' + randnum
    #     age  = rand(20)+20
    #     description = "very good"
    #     teacher = Teacher.new(name: name, age: age, description: description)
    #     teacher.save
    #     a += 1
    #   end
    #   return true        
    # end
  
    # #
    # # 创建测试数据2
    # #
    # # @author edgar.zhang <edgar.zhang@rccchina.com>
    # #
    # # @param [int] num 创建测试数据数量
    # #
    # # @return [boolean] true创建结束
    # #
    # def self.create_test_for(num)
    #   for i in 0..num
    #     randnum = rand(1000).to_s
    #     name = 'teacher-' + randnum
    #     age  = rand(20) + 20
    #     description = "very good"
    #     teacher = Teacher.new(name: name, age: age, description: description)
    #     teacher.save
    #   end  
    #   return true        
    # end
  
    # #
    # # 统计各个年龄的老师的人数
    # #
    # # @author edgar.zhang <edgar.zhang@rccchina.com>
    # #
    # # @return [hash] 年龄以及对应的数量
    # #
    # def self.count_age()
    #   Teacher.group("age").count
    # end
  
    # #
    # # 算出所有老师的年龄平均值
    # #
    # # @author edgar.zhang <edgar.zhang@rccchina.com>
    # #
    # # @return [hash] 平均年龄
    # #
    # def self.age_avg
    #   age = Teacher.find_by_sql("select AVG(age) as avg_age from teachers")[0]
    #   { age: age.avg_age }
    # end
  
    # #
    # # 根据所传年龄找到对应老师(按照name拍序)，并返回数量
    # #
    # # @author edgar.zhang <edgar.zhang@rccchina.com>
    # #
    # # @param [int] age 年龄
    # #
    # # @return [hash] 教师数据和数量
    # #
    # def self.find_teacher(age)
    #   teacher = Teacher.where(age: age).order(name: :desc)
    #   { list: teacher, count: teacher.size }
    # end
    
    # #
    # # 根据关键字查找description中包含关键字的教师数据,并把姓名和年龄用-连接返回一个数组
    # #
    # # @author edgar.zhang <edgar.zhang@rccchina.com>
    # #
    # # @param [string] description 关键字
    # #
    # # @return [array] 教师名称和年龄的拼接数组
    # #
    # def self.select_teacher(description)
    #   s = "%" + description + "%"
    #   teacher = Teacher.where("description like ?", s)
    #   result  = []
    #   teacher.each do |x|
    #       s = x.name + "-" + x.age.to_s
    #       result.push(s)
    #   end    
    #   result
    # end
  
    # #
    # # 根据id(支持一个或者多个),标记is_free的情况
    # #
    # # @author edgar.zhang <edgar.zhang@rccchina.com>
    # #
    # # @param [string] id 多个id用逗号隔开'1,2,3,4,5'
    # #
    # # @return [array] teacher列表数据
    # #
    # def self.free_teacher_byid(id)
    #   ids = id.split(',')
    #   teacher = Teacher.where(id: ids)
    #   result = []
    #   teacher.each do |one|
    #     tea = one.attributes
    #     if tea['is_free'] == 1
    #       tea['is_free'] = '空闲' 
    #     else
    #       tea['is_free'] = '不空闲' 
    #     end
    #     result.push(tea)    
    #   end
    #   result    
    # end
  
    # #
    # # 根据id(支持一个或多个),删除数据
    # #
    # # @author edgar.zhang <edgar.zhang@rccchina.com>
    # #
    # # @param [string] id 多个id用逗号隔开'1,2,3,4,5'
    # #
    # # @return [int] 删除数量
    # #
    # def self.del_teacher_byid(id)
    #   ids = id.split(',')
    #   Teacher.where(id: ids).delete_all
    # end
  
    # #
    # # 根据id,只展示name,age,description
    # #
    # # @author edgar.zhang <edgar.zhang@rccchina.com>
    # #
    # # @param [int] id
    # #
    # # @return [array] 展示name,age,description数据的数组
    # #
    # def self.get_teacher_byid(id)
    #   Teacher.where(id: id).pluck('name', 'age', 'description')
    # end
    
    # #
    # # 在每个年龄中各找出一条老师记录
    # #
    # # @author edgar.zhang <edgar.zhang@rccchina.com>
    # #
    # # @return [array] 老师数据
    # #
    # def self.get_teacher_byage()
    #   Teacher.find_by_sql("select * from teachers group by age")
    # end
  
    # #
    # # 传一个名字,判断记录是否存在，不存在就创建这个数据,然后返回数据
    # #
    # # @author edgar.zhang <edgar.zhang@rccchina.com>
    # #
    # # @param [string] name 老师名称
    # #
    # # @return [object] 老师数据
    # #
    # def self.judge_teacher(name)
    #   teacher = Teacher.where(name: name)
    #   if teacher.size == 0
    #       return Teacher.create(name: name)
    #   else
    #       return  teacher[0]  
    #   end    
    # end
  
    # #
    # # 进行列表查询，支持排序和分页
    # #
    # # @author edgar.zhang <edgar.zhang@rccchina.com>
    # #
    # # @param [int,int,string] page 页数 num 每页条数 order 排序字段
    # #
    # # @return [array] 老师数据
    # #
    # def self.list_teacher(page,num,order)
    #   page = page ? page.to_i : 1
    #   num = num ? num.to_i : 10
    #   order = order ? order : 'id'
    #   start = (page-1)*num
    #   sql = "select * from teachers"
    #   sql = sql + " order by " + order + " desc"
    #   sql = sql + " limit " + start.to_s + "," + num.to_s
    #   Teacher.find_by_sql(sql)
    # end
  end
  