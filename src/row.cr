struct TechCallCrystal::Row
  property user_id : Int32
  property task_id : Int32
  property duration : Int32
  property date : Time
  property comment : String

  def initialize(@user_id, @task_id, @duration, @date, @comment)
  end
end
