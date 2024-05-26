// Creating schema
CREATE OR REPLACE SCHEMA MANAGE_DB.file_formats;

//create file format object

CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.my_file_format;

// See the properties of file format object 

DESC FILE FORMAT MANAGE_DB.FILE_FORMATS.my_file_format;

//Alter the file format
ALTER FILE FORMAT MANAGE_DB.FILE_FORMATS.my_file_format
    SET SKIP_HEADER=1


// defining properties on creation of file format object 

CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.my_file_format
    TYPE='JSON'
    TIME_FORMAT='AUTO';


CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.csv_file_format
    TYPE='CSV'
    FIELD_DELIMITER=','
    SKIP_HEADER=1;
    
TRUNCATE MANAGE_DB.PUBLIC.ORDERS_EX1;

COPY INTO  MANAGE_DB.PUBLIC.ORDERS_EX1
FROM (SELECT 
        s.$1,
        s.$2,
        s.$3,
        CASE WHEN CAST(s.$3 as INT )<0 THEN 'NP' ELSE 'P' END     
        FROM @MANAGE_DB.EXTERNAL_STAGES.aws_stages s )
file_format = (FORMAT_NAME = MANAGE_DB.FILE_FORMATS.csv_file_format )
files=('OrderDetails.csv');












































