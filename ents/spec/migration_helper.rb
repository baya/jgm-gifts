module MigrationHelpers

  def drop_all_flex_tables
    dynamic_table_names = FlexTable.all.map(&:name)
    ActiveRecord::Migration.class_eval {
      dynamic_table_names.each{ |name| drop_table(name) if table_exists?(name)}
    }
  end

  def table_exists?(table_name)
    ActiveRecord::Base.connection.table_exists?(table_name)
  end

  def flex_record(chucai_table, chucai_fields)
    table = FlexTable.create!(chucai_table)
    chucai_fields.each do |field|
      FlexField.create!(field.merge(:table_id => table.id))
    end
  end

  def migrate(table, fields)
    ActiveRecord::Migration.class_eval {
      create_table table[:name] do |t|
        fields.each { |field| t.send(field[:value_type], field[:name] ) }
      end
    }
  end

   

end
