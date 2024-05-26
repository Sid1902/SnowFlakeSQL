    
    CREATE OR REPLACE storage integration s3_init
        TYPE = EXTERNAL_STAGE
        STORAGE_PROVIDER = S3
        ENABLED = TRUE
        STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::058264425719:role/snowflake-s3-connetion'
        STORAGE_ALLOWED_LOCATIONS = ('s3://json-demo-siddhant' ,'s3://dw-snowflake-ecom')
        COMMENT = 'Creating connection to S3';
    
    
    
    DESC integration s3_init;
    
    // create the table
    CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_S3_INT(
        ORDER_ID VARCHAR(30),
        AMOUNT INT,
        PROFIT  INT,
        QUANTITY INT,
        CATEGORY VARCHAR(30),
        SUBCATEGORY VARCHAR(30));
    
    //create file format object
    
    CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.CSV_FILE_FORMAT
        TYPE = 'CSV'
        FIELD_DELIMITER=','
        SKIP_HEADER=1
        NULL_IF = ('NULL','null')
        EMPTY_FIELD_AS_NULL = TRUE;
    
    // CREATE stage object with integration object & file format object
    CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.csv_folder
        URL = 's3://dw-snowflake-ecom/instacart/orders.csv'
        STORAGE_INTEGRATION = s3_init
        FILE_FORMAT = MANAGE_DB.file_formats.CSV_FILE_FORMAT
    
    // LOAD data using copy command
    
    COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_S3_INT
        FROM @MANAGE_DB.EXTERNAL_STAGES.csv_folder;
    
    
    
    
