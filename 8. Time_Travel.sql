CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.test(
    id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    gender STRING,
    job string,
    phone string
);

//create file format
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.CSV_FILE_FORMAT
    TYPE='CSV'
    FIELD_DELIMITER=','
    SKIP_HEADER = 1


CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    url='s3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.FILE_FORMATS.CSV_FILE_FORMAT

LIST @MANAGE_DB.external_stages.time_travel_stage


COPY INTO OUR_FIRST_DB.PUBLIC.test
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv')


// use case : update data by mistake 

UPDATE OUR_FIRST_DB.PUBLIC.test
SET first_name = 'Joyen';

// now here we forgot the where condition and hence entire data haas been changed

// Using time travel : Method 1-2 minutes back using offset

SELECT * FROM OUR_FIRST_DB.PUBLIC.test at (OFFSET => -60*4);


ALTER SESSION SET TIMEZONE = 'UTC';
SELECT CURRENT_TIMESTAMP;

// 2024-05-26 22:25:01.724 


// TIME TRAVEL USING TIMESTAMP
UPDATE OUR_FIRST_DB.PUBLIC.test
SET JOB = 'Data Scientist';


SELECT * FROM OUR_FIRST_DB.PUBLIC.test before (timestamp => '2024-05-26 22:22:01.724 '::timestamp);


SELECT * FROM OUR_FIRST_DB.PUBLIC.test;


//Wronng query's id :01b49863-3201-1936-0008-c6b20001d462
//time travel using query id

SELECT * FROM OUR_FIRST_DB.PUBLIC.test before (statement => '01b49863-3201-1936-0008-c6b20001d462');