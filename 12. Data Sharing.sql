CREATE OR REPLACE  DATABASE DATA_S;

CREATE OR REPLACE STAGE DATA_S.PUBLIC.aws_stage
    url='s3://bucketsnowflakes3'

//List files in stage

LIST @DATA_S.PUBLIC.aws_stage

//Create table
CREATE OR REPLACE TABLE ORDERS(
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT  INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));



//load data using Copy command

COPY INTO ORDERS
FROM @DATA_S.PUBLIC.AWS_STAGE
FILE_FORMAT = (TYPE='CSV' FIELD_DELIMITER=',' SKIP_HEADER=1)
PATTERN = '.*OrderDetails.*'


SELECT * FROM DATA_S.PUBLIC.ORDERS;

//Noe we want to share this data with other users

// For that we first create share object

CREATE OR REPLACE SHARE ORDERS_SHARE;

------- Setup Grants-----------

// Grant usage on database

GRANT USAGE ON DATABASE DATA_S TO SHARE ORDERS_SHARE;

//Grant usage on schema
GRANT USAGE ON SCHEMA DATA_S.PUBLIC TO SHARE ORDERS_SHARE;


//Grant SELECT on table
GRANT SELECT ON TABLE DATA_S.PUBLIC.ORDERS TO SHARE ORDERS_SHARE;

//vALIDATE Grants
SHOW GRANTS TO SHARE ORDERS_SHARE;

// Add consumer account to whom you want to share data .

ALTER SHARE ORDERS_SHARE ADD ACCOUNT =<consumer-account-id>



//Now we creater Reader access only account



--Create Reader Account----
CREATE  MANAGED ACCOUNT tech_joy_account
ADMIN_NAME = tech_joy_admin,// this would be the username 
ADMIN_PASSWORD = 'Sid@1902',
TYPE=READER;

//account  = UL60007
//"url" :https://uddedsz-tech_joy_account.snowflakecomputing.com
//Show accounts

SHOW MANAGED ACCOUNTS;


-----Share the data ----

ALTER SHARE ORDERS_SHARE
//ADD ACCOUNT = <reader-account-id>.
//Syntax to share the reader accouunt id 
ADD ACCOUNT = UL60007;


// USer side code 
SHOW SHARES;

DESC SHARE uddedsz.ug56189.ORDERS_SHARE;

CREATE DATABASE DATA_SHARE_DB FROM SHARE  uddedsz.ug56189.ORDERS_SHARE;

SELECT * FROM ORDERS;