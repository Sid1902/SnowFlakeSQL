//setting up table

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    url='s3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.FILE_FORMATS.CSV_FILE_FORMAT ;


CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.customers(
    id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    gender STRING,
    job string,
    phone string
);

COPY INTO OUR_FIRST_DB.PUBLIC.customers
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv') ;

SELECT * FROM OUR_FIRST_DB.PUBLIC.customers;


// Undrop command -tables

DROP TABLE OUR_FIRST_DB.public.customers;


UNDROP TABLE OUR_FIRST_DB.PUBLIC.customers;


























