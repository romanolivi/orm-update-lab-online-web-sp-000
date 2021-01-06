require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade
  
  def initialize(id=nil, name, grade)
    @id = id
    @name = name 
    @grade = grade
  end
  
  def self.create_table
    sql = "CREATE TABLE students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )"
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE students"
    
    DB[:conn].execute(sql)
  end
  
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    Student.new(id, name, grade)
  end
  
  def self.create(name, grade)
    student = Student.new(name, grade) 
    student.save
  end

  def save 
    if self.id 
      self.update
    else 
      
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL
      
      DB[:conn].execute(sql, self.name, self.grade)
      
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  
  end
  
  def self.find_by_name(x)
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE name = ?
    SQL
    
      DB[:conn].execute(sql, x).map do |row|
        self.new_from_db(row)
      end.first
  end
  
  def update 
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
    
end



