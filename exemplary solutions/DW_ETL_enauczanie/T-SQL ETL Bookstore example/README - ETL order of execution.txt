! Note that for testing purposes the ETL_load_employee.sql script
has a parametrizable EntryDate (can be understood as ETL's current timestamp).
In the actual ETL this piece of code would not exist
and @EntryDate would be replaced by CURRENT_TIMESTAMP. !

-- initial
create auxiliary tables
holidays
vacation
load date
drop auxiliary tables
load time
load junk
load unknown

-- data
load bookstores
load authors
load books
load employees
load authorship
load book sales

process the CUBE

-- MISSING FUNCTIONALITIES
- loading SCD2 related to Employees' boss change