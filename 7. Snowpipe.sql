// Create table first

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.employees(
    id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    location STRING,
    department STRING
)

//create file format
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.CSV_FILE_FORMAT
    TYPE='CSV'
    FIELD_DELIMITER=','
    SKIP_HEADER = 1
    NULL_IF = ('NULL','null')
    EMPTY_FIELD_AS_NULL =TRUE



//create dstage object with integration object & file format object

CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.CSV_FOLDER
    URL='s3://dw-snowflake-ecom/snowpipe/'
    STORAGE_INTEGRATION = s3_init
    FILE_FORMAT  = MANAGE_DB.FILE_FORMATS.CSV_FILE_FORMAT


LIST @MANAGE_DB.EXTERNAL_STAGES.CSV_FOLDER

// Create schema to keep all snowpipe files in it 

CREATE OR REPLACE SCHEMA MANAGE_DB.pipes

CREATE OR REPLACE PIPE MANAGE_DB.pipes.employee_pipe
auto_ingest = TRUE
AS
COPY INTO OUR_FIRST_DB.PUBLIC.employees
FROM @MANAGE_DB.EXTERNAL_STAGES.CSV_FOLDER;


DESC pipe MANAGE_DB.pipes.employee_pipe

SELECT * FROM OUR_FIRST_DB.PUBLIC.employees


SHOW PIPES;
SHOW PIPES like '%employee%'

SHOW PIPES in database MANAGE_DB

SHOW PIPES in schema MANAGE_DB.PIPES