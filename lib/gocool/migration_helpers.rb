module Gocool
  module MigrationHelpers

    def mysql?
      connection.adapter_name =~ /mysql/i
    end

    def add_foreign_key(from_table, from_column, to_table)
      return unless mysql?
      constraint_name = "fk_#{from_table}_#{from_column}"

      execute <<-SQL
        alter table #{from_table}
        add constraint #{constraint_name}
        foreign key (#{from_column})
        references #{to_table}(id)
      SQL
    end

    def remove_foreign_key(from_table, from_column)
      return unless mysql?
      constraint_name = "fk_#{from_table}_#{from_column}"

      execute %{alter table #{from_table} drop foreign key #{constraint_name}}
    end

  end
end
