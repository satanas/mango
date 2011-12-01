module MigrationHelper

  def add_foreign_key(org, field, dest)
    constraint_name="fk_#{org}_#{field}"
    sql="ALTER TABLE #{org} ADD CONSTRAINT #{constraint_name} FOREIGN KEY (#{field}) REFERENCES #{dest}(id)"
    execute sql
  end

  def drop_foreign_key(org, field)
    constraint_name="fk_#{org}_#{field}"
    sql="ALTER TABLE #{_org} DROP FOREIGN KEY #{constraint_name}"
    execute sql
  end

end
