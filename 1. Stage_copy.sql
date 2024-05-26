CREATE OR REPLACE DATABASE MANAGE_DB;

CREATE OR REPLACE SCHEMA external_stages;

// Creating external stage
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.aws_stage
    url='s3://dw-snowflake-ecom/instacart/'
    credentials=(AWS_KEY_ID = '****' AWS_SECRET_KEY ='**');


//Description of external stage
DESC STAGE MANAGE_DB.EXTERNAL_STAGES.aws_stage

ALTER STAGE aws_stage
SET credentials = (aws_key_id='XYZ_DUMMY' aws_secrey_key='xyz')

list @aws_stage


CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.aws_stages
    url='s3://bucketsnowflakes3';

CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.ORDERS(
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT  INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));



COPY INTO MANAGE_DB.PUBLIC.ORDERS
FROM @aws_stages
file_format = (type= 'csv',field_delimiter=',',skip_header=1)
files=('OrderDetails.csv');


select * from MANAGE_DB.PUBLIC.ORDERS;


CREATE TABLE MANAGE_DB.PUBLIC.ORDERS_EX(
    ORDER_ID VARCHAR(30),
    AMOUNT INT
);

COPY INTO MANAGE_DB.PUBLIC.ORDERS_EX
FROM (SELECT s.$1 , s.$2 FROM @MANAGE_DB.EXTERNAL_STAGES.aws_stages s)
file_format = (type= 'csv',field_delimiter=',',skip_header=1)
files=('OrderDetails.csv');


select * from manage_db.public.orders_ex;

CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.ORDERS_EX1(
            ORDER_ID VARCHAR(30),
            AMOUNT INT,
            PROFIT INT,
            CATEGORY_SUBSTRING VARCHAR(5)
);

COPY INTO  MANAGE_DB.PUBLIC.ORDERS_EX1
FROM (SELECT 
        s.$1,
        s.$2,
        s.$3,
        CASE WHEN CAST(s.$3 as INT )<0 THEN 'NP' ELSE 'P' END     
        FROM @MANAGE_DB.EXTERNAL_STAGES.aws_stages s )
file_format = (type= 'csv',field_delimiter=',',skip_header=1)
files=('OrderDetails.csv');


SELECT * FROM MANAGE_DB.PUBLIC.ORDERS_EX1;

























