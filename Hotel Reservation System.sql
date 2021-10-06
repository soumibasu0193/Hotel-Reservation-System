
CREATE TABLE Features
(
  Feature_ID_1        NUMBER          NOT NULL,
  Feature_Name   VARCHAR2(50)    NOT NULL,
  CONSTRAINT gl_accounts_pk
    PRIMARY KEY (account_number),
  CONSTRAINT gl_account_description_uq 
    UNIQUE (account_description)
);


CREATE TABLE general_ledger_accounts
(
  account_number        NUMBER          NOT NULL,
  account_description   VARCHAR2(50)    NOT NULL,
  CONSTRAINT gl_accounts_pk
    PRIMARY KEY (account_number),
  CONSTRAINT gl_account_description_uq 
    UNIQUE (account_description)
);



CREATE TABLE general_ledger_accounts
(
  account_number        NUMBER          NOT NULL,
  account_description   VARCHAR2(50)    NOT NULL,
  CONSTRAINT gl_accounts_pk
    PRIMARY KEY (account_number),
  CONSTRAINT gl_account_description_uq 
    UNIQUE (account_description)
);



CREATE TABLE general_ledger_accounts
(
  account_number        NUMBER          NOT NULL,
  account_description   VARCHAR2(50)    NOT NULL,
  CONSTRAINT gl_accounts_pk
    PRIMARY KEY (account_number),
  CONSTRAINT gl_account_description_uq 
    UNIQUE (account_description)
);