CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
    url='s3://json-demo-siddhant/HR_data.json'
    credentials=(AWS_KEY_ID = '**' AWS_SECRET_KEY ='**');

CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.JSONFORMAT
    TYPE='JSON';

CREATE OR REPLACE DATABASE OUR_FIRST_JSON_DB;

CREATE OR REPLACE TABLE OUR_FIRST_JSON_DB.PUBLIC.JSON_RAW(
    raw_file variant
);

COPY INTO OUR_FIRST_JSON_DB.PUBLIC.JSON_RAW
FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
FILE_FORMAT =  (FORMAT_NAME =  MANAGE_DB.FILE_FORMATS.JSONFORMAT )

SELECT * FROM OUR_FIRST_JSON_DB.PUBLIC.JSON_RAW


SELECT RAW_FILE:city, RAW_FILE:first_name FROM OUR_FIRST_JSON_DB.PUBLIC.JSON_RAW

SELECT $1:city, $1:first_name FROM OUR_FIRST_JSON_DB.PUBLIC.JSON_RAW



SELECT
    RAW_FILE:id ::int as id ,
    RAW_FILE:first_name :: string as first_name,
    RAW_FILE:last_name :: string as last_name,
    RAW_FILE:gender :: string as gender
FROM OUR_FIRST_JSON_DB.PUBLIC.JSON_RAW

SELECT RAW_FILE :  job as job FROM OUR_FIRST_JSON_DB.PUBLIC.JSON_RAW



SELECT RAW_FILE :job.salary as salary, RAW_FILE :job.title ::string as job_title FROM OUR_FIRST_JSON_DB.PUBLIC.JSON_RAW


SELECT RAW_FILE : prev_company,f.value as prev_company FROM OUR_FIRST_JSON_DB.PUBLIC.JSON_RAW,table(flatten(RAW_FILE:prev_company)) as f;

CREATE OR REPLACE TABLE Languages AS
select
    RAW_FILE:first_name ::STRING AS First_name,
    f.value : language :: 



















