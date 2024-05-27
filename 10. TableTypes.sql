CREATE OR REPLACE DATABASE PDB;


CREATE OR REPLACE TABLE PDB.public.customers(
    id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    gender STRING,
    job string,
    phone string
);

CREATE OR REPLACE TABLE PDB.public.helper(
    id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    gender STRING,
    job string,
    phone string
);

// create stage and file format

//create file format
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.CSV_FILE_FORMAT
    TYPE='CSV'
    FIELD_DELIMITER=','
    SKIP_HEADER = 1;

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    url='s3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.FILE_FORMATS.CSV_FILE_FORMAT ;


LIST @MANAGE_DB.external_stages.time_travel_stage;


COPY INTO PDB.PUBLIC.helper
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv') ;

SELECT * FROM PDB.PUBLIC.helper;

SHOW TABLES;


// transient table
CREATE OR REPLACE DATABASE TDB;

CREATE OR REPLACE TRANSIENT TABLE TDB.public.customer_transient(
    id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    gender STRING,
    job string,
    phone string
);

INSERT INTO TDB.PUBLIC.customer_transient
SELECT t1.* FROM OUR_FIRST_DB.PUBLIC.customers t1
CROSS JOIN (SELECT * FROM OUR_FIRST_DB.PUBLIC.customers) t2;

SHOW TABLES;


ALTER TABLE TDB.PUBLIC.customer_transient
SET DATA_RETENTION_TIME_IN_DAYS=1


//TEMPORARY TABLE 

CREATE OR REPLACE TEMPORARY TABLE PDB.PUBLIC.temp_table (
    id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    gender STRING,
    job string,
    phone string
);

INSERT INTO PDB.PUBLIC.temp_table
SELECT * FROM PDB.PUBLIC.CUSTOMERS
