CREATE OR  REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.aws_stages
        url='s3://bucketsnowflakes3';

// List files in stage .

LIST @MANAGE_DB.external_stages.aws_stages;


CREATE OR REPLACE TABLE OUR_FIRST_JSON_DB.PUBLIC.ORDERS(
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT ,
    QUANTITY INT ,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
    
);

//Load data using copy command

COPY INTO OUR_FIRST_JSON_DB.PUBLIC.ORDERS
FROM  @MANAGE_DB.EXTERNAL_STAGES.aws_stages
file_format = (type = 'csv',field_delimiter=',',skip_header=1)
pattern = 'OrderDetails.*';

// Create table

CREATE OR REPLACE TABLE ORDERS_CACHING (
    ORDER_ID VARCHAR(30),
    AMOUNT NUMBER(38,0),
    PROFIT NUMBER(38,0),
    QUANTITY NUMBER(38,0),
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30),
    DATE DATE
);
//inserting dummy data into table to get large data
INSERT INTO ORDERS_CACHING
SELECT 
t1.ORDER_ID,
t1.AMOUNT,
t1.PROFIT,
t1.QUANTITY,
t1.CATEGORY,
t1.SUBCATEGORY,
DATE(UNIFORM(1500000000,1700000000,RANDOM()))
FROM ORDERS t1
CROSS JOIN(SELECT * FROM ORDERS) t2
CROSS JOIN(SELECT TOP 100 * FROM ORDERS) t3


// Query performance before cluster key 

SELECT * FROM ORDERS_CACHING WHERE DATE = '2020-06-09'

// TIME TAKEN IS 2.5sec
// ONCE WHEN WE AGAIN RUN THE SAME QUERY IT EXECUTES IN 48ms . THIS IS HOW CACHING IMPROVISES PERFORMANCE

//ADDING CLUSTER KEY AND COMPARE THE RESULT

ALTER TABLE ORDERS_CACHING CLUSTER BY (DATE)

SELECT * FROM ORDERS_CACHING WHERE DATE = '2020-06-09';

// THIS QUERY EXECUTES IN 783ms AS WE CLUSTERED DATA AND HENCE WE CAN SEE PERFORMANCE OPTIMIZATION.

// SNOWFLAKE TAKES 45mins TO APPLY CLUSTERING AND IF WE RUN QUERY AFTER THAT RUNTIME WOULD BE <100ms

//In snowflake, by whatever column you cluster by you have to use  it as it is, eg : if you cluster by date then you cannot use month(date) for that yiu need to make another new cluster function.


ALTER TABLE ORDERS_CACHING CLUSTER BY (MONTH(DATE));

SELECT * FROM ORDERS_CACHING WHERE MONTH(DATE) = 11;






























































