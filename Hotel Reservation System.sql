
--------------------------------------------------------------
---- Some database cleaning
--------------------------------------------------------------
DROP SEQUENCE payment_id_seq;
DROP SEQUENCE reservation_id_seq;
DROP SEQUENCE room_id_seq;
DROP SEQUENCE location_id_seq;
DROP SEQUENCE feature_id_seq;
DROP SEQUENCE customer_id_seq; 


DROP TABLE reservation_details;
DROP TABLE room;
DROP TABLE location_features_linking;
DROP TABLE locations;
DROP TABLE features;
DROP TABLE customer_payment;
DROP TABLE reservation;
DROP TABLE customer;

------------------------------------------------------------
-- Creating tables and sequence for the Hotel Reservation System based on the ER diagram
------------------------------------------------------------
CREATE TABLE features
(
  featureID       NUMBER          NOT NULL,
  featureName     VARCHAR2(50)    NOT NULL,
  CONSTRAINT  feature_table_id_pk
    PRIMARY KEY (featureID),
  CONSTRAINT feature_name 
    UNIQUE (featureName)
);

CREATE TABLE locations
(
  locationID       NUMBER          NOT NULL,
  locationName     VARCHAR2(50)    NOT NULL,
  address          VARCHAR2(50)    NOT NULL,
  city             VARCHAR2(50)    NOT NULL,
  loc_state        CHAR(2)         NOT NULL,
  zip              NUMBER(5)       NOT NULL,
  phone            CHAR(12)        NOT NULL,
  loc_url          VARCHAR2(100)    NOT NULL,
  CONSTRAINT  location_table_id_pk
    PRIMARY KEY (locationID),
  CONSTRAINT location_name 
    UNIQUE (locationName),
    CONSTRAINT phone_format CHECK (regexp_like (phone,'^(\d{3}-\d{3}-?\d{4}|\d{10})$'))
);

CREATE TABLE location_features_linking
(
  locationID       NUMBER          NOT NULL,
  featureID        NUMBER          NOT NULL,
  CONSTRAINT  featureloc_id_pk
    PRIMARY KEY (locationID, featureID),
  CONSTRAINT feature_id_fk FOREIGN KEY (featureID) REFERENCES features(featureID),
  CONSTRAINT location_id_fk FOREIGN KEY (locationID) REFERENCES locations(locationID)
);


CREATE TABLE room
(
  roomID         NUMBER          NOT NULL,
  locationID     NUMBER          NOT NULL,
  floor          NUMBER          NOT NULL, --- displays the floor number, 1/2/3 etc
  room_number    NUMBER          NOT NULL,
  room_type      VARCHAR2(1)     NOT NULL, --- D/Q/K/S/C AS MENTIONED IN THE PROBLEM
  square_footage NUMBER          NOT NULL,
  max_people     NUMBER          NOT NULL, --- MENTIONS THE NO. OF PEOPLE THAT CAN STAY IN A ROOM 
  weekday_rate   NUMBER          NOT NULL, --- weekday rate in $
  weekend_rate   NUMBER          NOT NULL, --- weekend rate in $
  CONSTRAINT  room_id_pk
    PRIMARY KEY (roomID),
  CONSTRAINT room_location_id_fk FOREIGN KEY (locationID) REFERENCES locations(locationID),
  CONSTRAINT room_type_const 
    CHECK (regexp_like (room_type,'(D|Q|K|S|C)'))
);

CREATE TABLE customer
(
  customerID            NUMBER           NOT NULL,
  first_name            VARCHAR2(20)     NOT NULL, --- ASSUMING NAMES ARE USUALLY NOT LENGTHIER THAN 20 CHARACTERS
  last_name             VARCHAR2(20)     NOT NULL, --- ASSUMING NAMES ARE NOT LENGTHIER THAN 20 CHARACTERS
  email                 CHAR(50)         NOT NULL,
  phone                 CHAR(12)         DEFAULT    000-000-0000 , 
  address_line_1        VARCHAR2(50)     NOT NULL,
  address_line_2        VARCHAR2(50),               --- can be NULL
  city                  VARCHAR2(20)     NOT NULL,  --- ASSUMING CITY NAMES ARE NOT LENGTHIER THAN 20 CHARACTERS
  cust_state            CHAR(2)          NOT NULL,
  zip                   NUMBER(5)        NOT NULL,
  birthdate             DATE,                       --- can be NULL
  stay_credits_earned   NUMBER           DEFAULT 0,
  stay_credits_used     NUMBER           DEFAULT 0,
  CONSTRAINT  customer_id_pk
    PRIMARY KEY (customerID),
  CONSTRAINT customer_email 
    UNIQUE (email),
  CONSTRAINT credit_earned_used 
    CHECK (stay_credits_used <= stay_credits_earned),
  CONSTRAINT email_length_check 
    CHECK (length(email) >= 7),
  CONSTRAINT cust_phone_format
    CHECK (regexp_like (phone,'^(\d{3}-\d{3}-?\d{4}|\d{10})$'))  
);

CREATE TABLE reservation
(
  reservationID         NUMBER          NOT NULL,
  customerID            NUMBER          NOT NULL,
  confirmation_nbr      VARCHAR(8)      NOT NULL,
  date_created          DATE            DEFAULT SYSDATE,
  check_in_date         DATE            NOT NULL,
  check_out_date        DATE,                               --- can be NULL
  status                VARCHAR(1)      NOT NULL,
  discount_code         VARCHAR(12),                        --- can be NULL, MAX LENGTH OF 12 GIVEN IN HW1
  reservation_total     NUMBER          NOT NULL, 
  customer_rating       NUMBER,                             --- can be NULL, ASSUMING RATING IF THERE, CAN ONLY BE BETWEEN 1-5 
  notes                 VARCHAR2(50),                       --- can be NULL
  CONSTRAINT  reservation_id_pk
    PRIMARY KEY (reservationID),
  CONSTRAINT customer_id_fk FOREIGN KEY (customerID) REFERENCES customer(customerID),
  CONSTRAINT conf_number UNIQUE (confirmation_nbr), 
  CONSTRAINT reservation_status 
    CHECK (regexp_like (status,'(U|I|C|N|R)')),
  CONSTRAINT rating_check 
    CHECK (customer_rating BETWEEN 1 AND 5) --- checking for the rating to lie between 1-5
);

CREATE TABLE reservation_details
(
  reservationID       NUMBER          NOT NULL,
  roomID              NUMBER          NOT NULL,
  number_of_guests    NUMBER          NOT NULL,
  CONSTRAINT room_details_id_pk 
    PRIMARY KEY (roomID, reservationID),
    CONSTRAINT reservation_details_id_fk FOREIGN KEY (reservationID) REFERENCES reservation(reservationID),
    CONSTRAINT room_details_id_fk FOREIGN KEY (roomID) REFERENCES room(roomID)
);

CREATE TABLE customer_payment
(
  paymentID             NUMBER          NOT NULL,
  customerID            NUMBER          NOT NULL,
  cardholder_fn         VARCHAR(20)     NOT NULL, --- assuming customer first name cannot be more than 20 characters
  cardholder_mn         VARCHAR(20),              --- assuming customer middle name cannot be more than 20 characters, this field can be NULL based on the understanding that not everyone has a middle name
  cardholder_ln         VARCHAR(20)     NOT NULL, --- assuming customer last name cannot be more than 20 characters
  card_type             CHAR(4)         NOT NULL,
  card_number           NUMBER(16)      NOT NULL, --- as given in HW1 that card number is 15-16 digits
  exp_date              DATE            NOT NULL,
  cc_id                 NUMBER(3)       NOT NULL, --- since the cc_id is a 3-digit code
  billing_address       VARCHAR(100)    NOT NULL, 
  billing_city          VARCHAR2(20)    NOT NULL, --- ASSUMING CITY NAMES ARE NOT LENGTHIER THAN 20 CHARACTERS,
  billing_state         CHAR(2)         NOT NULL,
  billing_zip           NUMBER(5)       NOT NULL,
  CONSTRAINT  payment_id_pk
    PRIMARY KEY (paymentID),
  CONSTRAINT customer_pay_id_fk FOREIGN KEY (customerID) REFERENCES customer(customerID),
  CONSTRAINT card_no_check 
    CHECK (card_number >=15),
  CONSTRAINT cc_id_check 
    CHECK (length(cc_id) = 3)
);

---- Creating sequence for the tables

  CREATE SEQUENCE payment_id_seq
    START WITH 1 INCREMENT BY 1;

  CREATE SEQUENCE reservation_id_seq
    START WITH 1 INCREMENT BY 1;
    
  CREATE SEQUENCE room_id_seq
    START WITH 1 INCREMENT BY 1;
    
  CREATE SEQUENCE location_id_seq
    START WITH 1 INCREMENT BY 1;
    
  CREATE SEQUENCE feature_id_seq
    START WITH 1 INCREMENT BY 1;
    
  -- sequence for customer_id
  CREATE SEQUENCE customer_id_seq
    START WITH 100001 INCREMENT BY 1;

------------------------------------------------------------------------------------------
--- Creating indexes for the foreign keys in respective tables that are not also primary keys
------------------------------------------------------------------------------------------

CREATE INDEX rom_loc_ix 
  ON room (locationID);

CREATE INDEX reservation_ix 
  ON reservation (customerID);

CREATE INDEX customer_payment_ix 
  ON customer_payment (customerID);
  
--- Indexing two other columns from the schema

--- Creating index to be able to query through the database to find only the rooms on a particular floor 
CREATE INDEX floor_ix ON room (floor); 

--- Creating index to be able to query through the database to find only the bookings on a particular date
CREATE INDEX date_created_ix ON reservation (date_created);

------------------------------------------------------------------------------------------
--- Inserting into the database
------------------------------------------------------------------------------------------

INSERT INTO locations
VALUES (location_id_seq.NEXTVAL , 'South Congress', '1826 Easy Street', 'Austin', 'TX', '78700', '512-123-4567', 'https://www.sourapplehotels.us/south_congress');

INSERT INTO locations
VALUES (location_id_seq.NEXTVAL , 'East 7th Lofts', '8391 Bulls Rd', 'Austin', 'TX', '78123','123-234-3455', 'https://www.sourapplehotels.us/east_lofts');

INSERT INTO locations
VALUES (location_id_seq.NEXTVAL , 'Balcones Canyonlands', '987 Looney Ln', 'Marble Falls', 'TX','79703', '514-354-0101', 'https://www.sourapplehotels.us/balcones_canyonlands');

COMMIT;

--- Inserting features

INSERT INTO features
VALUES (feature_id_seq.NEXTVAL, 'Free Wi-Fi');

INSERT INTO features
VALUES (feature_id_seq.NEXTVAL, 'Free Breakfast');

INSERT INTO features
VALUES (feature_id_seq.NEXTVAL, 'Free Parking');

COMMIT;

--- Insert into location_features_linking

INSERT INTO location_features_linking (locationID, featureID) VALUES ((SELECT locationID FROM locations WHERE locationName = 'South Congress'),(SELECT featureID FROM features WHERE featureName = 'Free Parking'));
INSERT INTO location_features_linking (locationID, featureID) VALUES ((SELECT locationID FROM locations WHERE locationName = 'South Congress'),(SELECT featureID FROM features WHERE featureName = 'Free Breakfast'));

INSERT INTO location_features_linking (locationID, featureID) VALUES ((SELECT locationID FROM locations WHERE locationName = 'Balcones Canyonlands'),(SELECT featureID FROM features WHERE featureName = 'Free Breakfast'));
INSERT INTO location_features_linking (locationID, featureID) VALUES ((SELECT locationID FROM locations WHERE locationName = 'Balcones Canyonlands'),(SELECT featureID FROM features WHERE featureName = 'Free Parking'));

INSERT INTO location_features_linking (locationID, featureID) VALUES ((SELECT locationID FROM locations WHERE locationName = 'East 7th Lofts'),(SELECT featureID FROM features WHERE featureName = 'Free Parking'));
INSERT INTO location_features_linking (locationID, featureID) VALUES ((SELECT locationID FROM locations WHERE locationName = 'East 7th Lofts'),(SELECT featureID FROM features WHERE featureName = 'Free Wi-Fi'));

COMMIT;

--- Inserting in rooms table (2 per location)
 
INSERT INTO room
VALUES (room_id_seq.NEXTVAL, (SELECT locationID FROM locations WHERE locationName = 'South Congress'), 1, 101, 'D', 400, 2, 82, 110);
INSERT INTO room
VALUES (room_id_seq.NEXTVAL, (SELECT locationID FROM locations WHERE locationName = 'South Congress'), 1, 111, 'Q', 300, 1, 52, 70);
INSERT INTO room
VALUES (room_id_seq.NEXTVAL, (SELECT locationID FROM locations WHERE locationName = 'Balcones Canyonlands'), 2, 211, 'K', 500, 2, 85, 115);
INSERT INTO room
VALUES (room_id_seq.NEXTVAL, (SELECT locationID FROM locations WHERE locationName = 'Balcones Canyonlands'), 1, 121, 'S', 800, 8, 132, 150);
INSERT INTO room
VALUES (room_id_seq.NEXTVAL, (SELECT locationID FROM locations WHERE locationName = 'East 7th Lofts'), 1, 1011, 'D', 400, 2, 82, 110);
INSERT INTO room
VALUES (room_id_seq.NEXTVAL, (SELECT locationID FROM locations WHERE locationName = 'East 7th Lofts'), 2, 2121, 'C', 100, 1, 45, 50);

COMMIT;

--- Inserting into the customer table
  
INSERT INTO customer 
VALUES (customer_id_seq.NEXTVAL, 'Soumi', 'Basu', 'sb59982@utexas.edu', '412-111-1234','Nowhere on earth, 1111', NULL, 'NoCity', 'AA', 77777, NULL , 10, 2 );
INSERT INTO customer 
VALUES (customer_id_seq.NEXTVAL, 'Richard', 'Parker', 'richard.park@fb.com', '122-134-4324','Wonderland', '2722', 'San Diego', 'CL', 12345, TO_DATE('12/25/2000', 'MM/DD/YYYY') , 100, 54 );

COMMIT;

--- Inserting into the customer_payments table
  
INSERT INTO customer_payment 
VALUES (payment_id_seq.NEXTVAL, (SELECT customerID FROM customer WHERE first_name = 'Soumi'), 'Soumi', NULL, 'Basu', 1111, 3263487236741874,  TO_DATE('12/21/2026', 'MM/DD/YYYY'), 111, 'Nowhere on earth, 1111', 'NoCity', 'AA', 77777);

INSERT INTO customer_payment 
VALUES (payment_id_seq.NEXTVAL, (SELECT customerID FROM customer WHERE first_name = 'Richard'), 'Richard', 'Dancing', 'Parker', 1234, 3373584235742865,  TO_DATE('10/25/2028', 'MM/DD/YYYY'), 123, 'Wonderland', 'San Diego', 'CL', 12345);

COMMIT;

--- Inserting into reservation and reservation_details tables
  
/* Reservation for customer 1 */
INSERT INTO reservation
VALUES (reservation_id_seq.NEXTVAL, (SELECT customerID FROM customer WHERE first_name = 'Soumi'), 12341234,NULL, TO_DATE('10/05/2021', 'MM/DD/YYYY'), TO_DATE('10/15/2021', 'MM/DD/YYYY'), 'C', NULL, 1500, 4, NULL);
COMMIT;

INSERT INTO reservation_details
VALUES ((SELECT reservationID FROM reservation WHERE confirmation_nbr = 12341234), (SELECT roomID from room WHERE room_number = 111),3);
COMMIT;

/* Reservation for customer 2 */
INSERT INTO reservation
VALUES (reservation_id_seq.NEXTVAL, (SELECT customerID FROM customer WHERE first_name = 'Richard'), 21546753,TO_DATE('10/08/2021', 'MM/DD/YYYY'), TO_DATE('10/08/2021', 'MM/DD/YYYY'), TO_DATE('10/10/2021', 'MM/DD/YYYY'), 'U', 'AKKDJF11', 789, 3, 'Decent');

INSERT INTO reservation
VALUES (reservation_id_seq.NEXTVAL, (SELECT customerID FROM customer WHERE first_name = 'Richard'), 27346411,TO_DATE('10/08/2020', 'MM/DD/YYYY'), TO_DATE('10/08/2020', 'MM/DD/YYYY'), TO_DATE('10/10/2020', 'MM/DD/YYYY'), 'C', NULL, 1823, 4, 'Good Service');

COMMIT;

INSERT INTO reservation_details
VALUES ((SELECT reservationID FROM reservation WHERE confirmation_nbr = 21546753 AND check_in_date = TO_DATE('10/08/2021', 'MM/DD/YYYY')), (SELECT roomID from room WHERE room_number = 2121),3);

INSERT INTO reservation_details
VALUES ((SELECT reservationID FROM reservation WHERE confirmation_nbr = 27346411 AND check_in_date = TO_DATE('10/08/2020', 'MM/DD/YYYY')), (SELECT roomID from room WHERE room_number = 121),5);
COMMIT;

--- DATABASE CREATED

SELECT * FROM customer;
SELECT * FROM customer_payment;
SELECT * FROM reservation_details;