class Dog
    # creating a table
    def self.create_table
        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
          )
        SQL

        DB[:conn].execute(sql)
    end

    # dropping a table
    def self.drop_table
        sql = <<-SQL
            DROP TABLE IF EXISTS songs
        SQL

        DB[:conn].execute(sql)
    end
    # initializing attributes
    def initialize(attributes)
        attributes.each { |key, value| send("#{key}=", value) }
    end

    # adding a new instance 
    
    def save
      if self.id
        update
      else
        sql = <<-SQL
          INSERT INTO dogs (name, breed)
          VALUES (?, ?)
        SQL
  
        DB[:conn].execute(sql, self.name, self.breed)
        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      end
      self
    end

    def update
        sql = <<-SQL
          UPDATE dogs
          SET name = ?, breed = ?
          WHERE id = ?
        SQL
    
        DB[:conn].execute(sql, self.name, self.breed, self.id)
    end

    # usng the save method to create 
    def self.create(attributes)
        dog = Dog.new(attributes)
        dog.save
    end

    # return an array representing a dog's data
    def self.new_from_array(array)
        attributes = { id: array[0], name: array[1], breed: array[2] }
        Dog.new(attributes)
    end

    def self.new_from_array(array)
        attributes = { id: array[0], name: array[1], breed: array[2] }
        Dog.new(attributes)
    end

    # method to return an array of Dog instances for every record in the dogs table.
    def self.all
        sql = "SELECT * FROM dogs"
        results = DB[:conn].execute(sql)
        results.map { |row| Dog.new_from_array(row) }
    end
#  method will first insert a dog into the database and then attempt to find it by calling the find_by_name method.
    def self.find_by_name(name)
        sql = "SELECT * FROM dogs WHERE name = ? LIMIT 1"
        result = DB[:conn].execute(sql, name).first
    
        if result
          Dog.new_from_array(result)
        else
          nil
        end
    end
    # method takes in an ID
    # return a single Dog instance for the corresponding record in the dogs table with that same ID
    def self.find_by_id(id)
        sql = "SELECT * FROM dogs WHERE id = ? LIMIT 1"
        result = DB[:conn].execute(sql, id).first
    
        if result
          Dog.new_from_array(result)
        else
          nil
        end
    end




end
