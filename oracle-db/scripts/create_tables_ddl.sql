-- PK draft_id_seq.nextval
CREATE TABLE DRAFT
(
--  DRAFT_ID             NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  DRAFT_ID             NUMBER NOT NULL,
  DOCUMENT_NUMBER      VARCHAR2(10) NOT NULL,
  ACCOUNT_ID           VARCHAR2(20) NOT NULL,
  CREATE_TS            DATE NOT NULL,
  REGISTRATION_TYPE_CL VARCHAR2(10 BYTE) NOT NULL, 
  REGISTRATION_TYPE_CD CHAR(2 BYTE) NOT NULL,
  REGISTRATION_ID      NUMBER NULL,
  REGISTRATION_NUMBER  VARCHAR2(10 BYTE) NULL, 
  UPDATE_TS            DATE NULL,
  DRAFT                CLOB NOT NULL
)
;
ALTER TABLE draft
  ADD CONSTRAINT draft_pk PRIMARY KEY (draft_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE draft
  ADD CONSTRAINT draft_reg_type_fk FOREIGN KEY (registration_type_cd)
  REFERENCES registration_type(registration_type_cd)
;
ALTER TABLE draft
  ADD CONSTRAINT draft_reg_class_fk FOREIGN KEY (registration_type_cl)
  REFERENCES registration_type_class(registration_type_cl)
;
ALTER TABLE draft
  ADD CONSTRAINT draft_reg_id_fk FOREIGN KEY (registration_id)
  REFERENCES registration(registration_id)
;
ALTER TABLE draft
  ADD CONSTRAINT draft_docu_num_unique UNIQUE(document_number);


-- PK financing_id_seq.nextval
CREATE TABLE FINANCING_STATEMENT
(  
--financing_id         NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  financing_id          NUMBER NOT NULL,
  STATE_TYPE_CD        CHAR(3 BYTE) NOT NULL,
  REGISTRATION_NUMBER  VARCHAR2(10 BYTE) NOT NULL,
  EXPIRE_DATE          DATE,
  LIFE                 NUMBER,
  DISCHARGED           CHAR(1 BYTE),
  RENEWED              CHAR(1 BYTE),
  TYPE_CLAIM           VARCHAR2(2 BYTE),
  CROWN_CHARGE_TYPE    VARCHAR2(2 BYTE),
  CROWN_CHARGE_OTHER   VARCHAR2(70 BYTE),
  PREV_REG_TYPE        VARCHAR2(30 BYTE),
  PREV_REG_CR_NBR      VARCHAR2(7 BYTE),
  PREV_REG_CR_DATE     VARCHAR2(7 BYTE), 
  PREV_REG_CB_NBR      VARCHAR2(10 BYTE),
  PREV_REG_CB_DATE     VARCHAR2(7 BYTE),
  PREV_REG_MH_NBR      VARCHAR2(7 BYTE),
  PREV_REG_MH_DATE     VARCHAR2(7 BYTE) 
)
;
COMMENT ON COLUMN FINANCING_STATEMENT.DISCHARGED IS 'required for IMS reg';
COMMENT ON COLUMN FINANCING_STATEMENT.RENEWED IS 'required for IMS reg';
COMMENT ON COLUMN FINANCING_STATEMENT.TYPE_CLAIM IS 'required for IMS reg';
COMMENT ON COLUMN FINANCING_STATEMENT.CROWN_CHARGE_TYPE IS 'required for IMS reg';
COMMENT ON COLUMN FINANCING_STATEMENT.CROWN_CHARGE_OTHER IS 'required for IMS reg';
COMMENT ON COLUMN FINANCING_STATEMENT.PREV_REG_TYPE IS 'required for IMS reg';
COMMENT ON COLUMN FINANCING_STATEMENT.PREV_REG_CR_NBR IS 'required for IMS reg';
COMMENT ON COLUMN FINANCING_STATEMENT.PREV_REG_CR_DATE IS 'required for IMS reg';
COMMENT ON COLUMN FINANCING_STATEMENT.PREV_REG_CB_NBR IS 'required for IMS reg';
COMMENT ON COLUMN FINANCING_STATEMENT.PREV_REG_CB_DATE IS 'required for IMS reg';
COMMENT ON COLUMN FINANCING_STATEMENT.PREV_REG_MH_NBR IS 'required for IMS reg';
COMMENT ON COLUMN FINANCING_STATEMENT.PREV_REG_MH_DATE IS 'required for IMS reg';
ALTER TABLE financing_statement
  ADD CONSTRAINT financing_statement_pk PRIMARY KEY (financing_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE financing_statement
  ADD CONSTRAINT financing_state_fk FOREIGN KEY (state_type_cd)
  REFERENCES state_type(state_type_cd)
;

-- PK registration_id_seq.nextval
CREATE TABLE REGISTRATION
(
--REGISTRATION_ID      NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  REGISTRATION_ID      NUMBER NOT NULL,
  FINANCING_ID         NUMBER NOT NULL,
  REGISTRATION_NUMBER  VARCHAR2(10 BYTE) NOT NULL,
  BASE_REG_NUMBER      VARCHAR2(10 BYTE) NULL,
  REGISTRATION_TYPE_CL VARCHAR2(10 BYTE) NOT NULL, 
  REGISTRATION_TYPE_CD CHAR(2 BYTE) NOT NULL, 
  REGISTRATION_TS      DATE NOT NULL,
  LIFE                 NUMBER,
  SURRENDER_DATE       DATE,
  LIEN_VALUE           VARCHAR2(15 BYTE),
  USER_ID              VARCHAR2(1000 BYTE),
  ACCOUNT_ID           VARCHAR2(20 BYTE),
  CLIENT_REFERENCE_ID  VARCHAR2(20 BYTE),
  PAY_INVOICE_ID       NUMBER,
  PAY_PATH             VARCHAR2(256 BYTE),
  VER_BYPASSED         VARCHAR2(1 BYTE),
  DETAIL_DESCRIPTION   VARCHAR2(180 BYTE),
  SP_NUMBER            NUMBER, 
  DE_NUMBER            NUMBER, 
  VE_NUMBER            NUMBER, 
  DOCUMENT_NUMBER      VARCHAR2(10 BYTE)  NOT NULL
)
;
COMMENT ON COLUMN REGISTRATION.DETAIL_DESCRIPTION IS 'required for IMS reg';
COMMENT ON COLUMN REGISTRATION.SP_NUMBER IS 'required for IMS reg';
COMMENT ON COLUMN REGISTRATION.DE_NUMBER IS 'required for IMS reg';
COMMENT ON COLUMN REGISTRATION.VE_NUMBER IS 'required for IMS reg';
COMMENT ON COLUMN REGISTRATION.USER_ID IS 'Not used by API';
COMMENT ON COLUMN REGISTRATION.VER_BYPASSED IS 'Not used by API';
ALTER TABLE registration
  ADD CONSTRAINT registration_pk PRIMARY KEY (registration_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE registration
  ADD CONSTRAINT registration_reg_type_fk FOREIGN KEY (registration_type_cd)
  REFERENCES registration_type(registration_type_cd)
;
ALTER TABLE registration
  ADD CONSTRAINT registration_reg_class_fk FOREIGN KEY (registration_type_cl)
  REFERENCES registration_type_class(registration_type_cl)
;
ALTER TABLE registration
  ADD CONSTRAINT reg_financing_id_fk FOREIGN KEY (financing_id)
  REFERENCES financing_statement(financing_id)
;
ALTER TABLE registration
  ADD CONSTRAINT reg_doc_number_fk FOREIGN KEY (document_number)
  REFERENCES draft(document_number)
;
ALTER TABLE registration
  ADD CONSTRAINT reg_num_unique UNIQUE(registration_number)
;
CREATE INDEX reg_date_index ON registration(reg_date)
      TABLESPACE PPR_INDEX
;
CREATE INDEX reg_base_reg_num_index ON registration(BASE_REG_NUMBER)
      TABLESPACE PPR_INDEX
;

-- PK trust_indenture_id_seq.nextval
CREATE TABLE TRUST_INDENTURE
(  
--trust_id             NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  trust_id             NUMBER NOT NULL,
  REGISTRATION_ID      NUMBER NOT NULL,
  FINANCING_ID         NUMBER NOT NULL, 
  TRUST_INDENTURE      CHAR(1 BYTE),
  REGISTRATION_ID_END  NUMBER
)
;
ALTER TABLE trust_indenture
  ADD CONSTRAINT trust_pk PRIMARY KEY (trust_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE trust_indenture
  ADD CONSTRAINT trust_reg_id_fk FOREIGN KEY (registration_id)
  REFERENCES registration(registration_id)
;
ALTER TABLE trust_indenture
  ADD CONSTRAINT trust_financing_id_fk FOREIGN KEY (financing_id)
  REFERENCES financing_statement(financing_id)
;
ALTER TABLE trust_indenture
  ADD CONSTRAINT trust_reg_id_end_fk FOREIGN KEY (registration_id_end)
  REFERENCES registration(registration_id)
;


-- PK court_order_id_seq.nextval
CREATE TABLE COURT_ORDER
(  
--court_order_id       NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  court_order_id       NUMBER NOT NULL,
  REGISTRATION_ID      NUMBER NOT NULL,
  COURT_DATE           DATE NOT NULL, 
  COURT_NAME           VARCHAR2(256 BYTE),
  COURT_REGISTRY       VARCHAR2(64 BYTE),
  FILE_NUMBER          VARCHAR2(20 BYTE),
  EFFECT_OF_ORDER      VARCHAR2(512 BYTE)
)
;
ALTER TABLE court_order
  ADD CONSTRAINT court_order_pk PRIMARY KEY (court_order_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE court_order
  ADD CONSTRAINT court_order_reg_id_fk FOREIGN KEY (registration_id)
  REFERENCES registration(registration_id)
;


-- PK address_id_seq.nextval
CREATE TABLE ADDRESS_PPR (
--address_id           NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  address_id           NUMBER NOT NULL,
  STREET_LINE_1        VARCHAR2(50 BYTE),
  STREET_LINE_2        VARCHAR2(50 BYTE),
  CITY                 VARCHAR2(30 BYTE),
  PROVINCE_TYPE_CD     CHAR(2 BYTE),
  COUNTRY_TYPE_CD      CHAR(2 BYTE),
  POSTAL_CD            VARCHAR2(15 BYTE)
)
;
ALTER TABLE ADDRESS_PPR
  ADD CONSTRAINT address_pk PRIMARY KEY (address_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE ADDRESS_PPR
  ADD CONSTRAINT address_prov_type_fk FOREIGN KEY (PROVINCE_TYPE_CD)
  REFERENCES PROVINCE_TYPES(PROVINCE_TYPE_CD)
;
ALTER TABLE ADDRESS_PPR
  ADD CONSTRAINT address_country_type_fk FOREIGN KEY (country_type_cd)
  REFERENCES country_types(country_type_cd)
;

-- PK client_party_id_seq.nextval
CREATE TABLE CLIENT_PARTY
(
--client_party_id      NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  client_party_id      NUMBER NOT NULL,
  PARTY_TYPE_CD        CHAR(2 BYTE) NOT NULL,
  ACCOUNT_ID           VARCHAR2(20 BYTE),
  PARTY_NAME VARCHAR2(150 BYTE),
  EMAIL_ID             VARCHAR2(256 BYTE),
  CONTACT_NAME         VARCHAR2(100 BYTE),
  CONTACT_AREA_CD      CHAR(3 BYTE),
  CONTACT_PHONE_NUMBER VARCHAR2(15 BYTE),
  USER_ID              VARCHAR2(7 BYTE),
  LAST_UPDATE          VARCHAR2(8 BYTE),
  LAST_UPDATE_TIME     VARCHAR2(8 BYTE),
  BCOL_ACCOUNT_NBR     VARCHAR2(6 BYTE),
  HISTORY_COUNT        NUMBER,
  BRANCH_COUNT         NUMBER,
  ADDRESS_ID           NUMBER
)
;
COMMENT ON COLUMN CLIENT_PARTY.USER_ID IS 'required IMS';
COMMENT ON COLUMN CLIENT_PARTY.LAST_UPDATE IS 'required IMS';
COMMENT ON COLUMN CLIENT_PARTY.LAST_UPDATE_TIME IS 'required IMS';
COMMENT ON COLUMN CLIENT_PARTY.BCOL_ACCOUNT_NBR IS 'required IMS';
COMMENT ON COLUMN CLIENT_PARTY.HISTORY_COUNT IS 'required IMS';
COMMENT ON COLUMN CLIENT_PARTY.BRANCH_COUNT IS 'required IMS';
ALTER TABLE client_party
  ADD CONSTRAINT client_party_pk PRIMARY KEY (client_party_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE client_party
  ADD CONSTRAINT client_party_type_fk FOREIGN KEY (party_type_cd)
  REFERENCES party_type(party_type_cd)
;
ALTER TABLE client_party
  ADD CONSTRAINT client_party_address_fk FOREIGN KEY (address_id)
  REFERENCES address_ppr(address_id)
;

-- PK party_id_seq.nextval
CREATE TABLE PARTY
(
--party_id             NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  party_id             NUMBER NOT NULL,
  PARTY_TYPE_CD        CHAR(2 BYTE) NOT NULL, 
  REGISTRATION_ID      NUMBER NOT NULL,
  FINANCING_ID         NUMBER NOT NULL, 
  CLIENT_PARTY_ID      NUMBER,
  BUSINESS_NAME        VARCHAR2(150 BYTE),
  LAST_NAME            VARCHAR2(50 BYTE),
  FIRST_NAME           VARCHAR2(50 BYTE),
  MIDDLE_NAME          VARCHAR2(50 BYTE),
  FIRST_NAME_KEY       VARCHAR2(50 BYTE),
  LAST_NAME_KEY        VARCHAR2(50 BYTE),
  BUSINESS_SRCH_KEY    VARCHAR2(150 BYTE),
  BIRTH_DATE           DATE,
  ADDRESS_ID           NUMBER,
  REGISTRATION_ID_END  NUMBER,
  BLOCK_NUMBER         NUMBER
)
;
COMMENT ON COLUMN PARTY.FIRST_NAME_KEY IS 'required for search';
COMMENT ON COLUMN PARTY.LAST_NAME_KEY IS 'required for search';
COMMENT ON COLUMN PARTY.BUSINESS_SRCH_KEY IS 'required for search';
ALTER TABLE party
  ADD CONSTRAINT party_pk PRIMARY KEY (party_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE party
  ADD CONSTRAINT party_party_type_fk FOREIGN KEY (party_type_cd)
  REFERENCES party_type(party_type_cd)
;
ALTER TABLE party
  ADD CONSTRAINT party_address_fk FOREIGN KEY (address_id)
  REFERENCES address_ppr(address_id)
;
ALTER TABLE party
  ADD CONSTRAINT party_client_party_fk FOREIGN KEY (client_party_id)
  REFERENCES client_party(client_party_id)
;
ALTER TABLE party
  ADD CONSTRAINT party_reg_id_fk FOREIGN KEY (registration_id)
  REFERENCES registration(registration_id)
;
ALTER TABLE party
  ADD CONSTRAINT party_financing_id_fk FOREIGN KEY (financing_id)
  REFERENCES financing_statement(financing_id)
;
ALTER TABLE party
  ADD CONSTRAINT party_reg_id_end_fk FOREIGN KEY (registration_id_end)
  REFERENCES registration(registration_id)
;

-- PK serial_collateral_id_seq.nextval
CREATE TABLE SERIAL_COLLATERAL
(
--serial_id   NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  serial_id              NUMBER NOT NULL,
  SERIAL_TYPE_CD         CHAR(2 BYTE) NOT NULL, 
  REGISTRATION_ID        NUMBER NOT NULL,
  FINANCING_ID           NUMBER NOT NULL,
  YEAR                   NUMBER,
  MAKE                   VARCHAR2(60 BYTE),
  MODEL                  VARCHAR2(60 BYTE),
  SERIAL_NUMBER          VARCHAR2(30 BYTE),
  MHR_NUMBER             VARCHAR2(6 BYTE),
  SRCH_VIN               VARCHAR2(6 BYTE),
  REGISTRATION_ID_END    NUMBER,
  BLOCK_NUMBER           NUMBER
)
;
ALTER TABLE serial_collateral
  ADD CONSTRAINT serial_collateral_pk PRIMARY KEY (serial_collateral_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE serial_collateral
  ADD CONSTRAINT v_collateral_type_fk FOREIGN KEY (serial_type_cd)
  REFERENCES serial_type(serial_type_cd)
;
ALTER TABLE serial_collateral
  ADD CONSTRAINT vc_reg_id_fk FOREIGN KEY (registration_id)
  REFERENCES registration(registration_id)
;
ALTER TABLE serial_collateral
  ADD CONSTRAINT vc_financing_id_fk FOREIGN KEY (financing_id)
  REFERENCES financing_statement(financing_id)
;
ALTER TABLE serial_collateral
  ADD CONSTRAINT vc_reg_id_end_fk FOREIGN KEY (registration_id_end)
  REFERENCES registration(registration_id)
;

-- PK general_collateral_id_seq.nextval
CREATE TABLE GENERAL_COLLATERAL
(
--general_collateral_id  NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  general_collateral_id  NUMBER NOT NULL,
  REGISTRATION_ID        NUMBER NOT NULL,
  FINANCING_ID           NUMBER NOT NULL,
  DESCRIPTION            VARCHAR2(4000 BYTE),
  REGISTRATION_ID_END    NUMBER,
  STATUS                 VARCHAR2(1 BYTE)
)
;
ALTER TABLE general_collateral
  ADD CONSTRAINT general_collateral_pk PRIMARY KEY (general_collateral_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE general_collateral
  ADD CONSTRAINT gc_reg_id_fk FOREIGN KEY (registration_id)
  REFERENCES registration(registration_id)
;
ALTER TABLE general_collateral
  ADD CONSTRAINT gc_financing_id_fk FOREIGN KEY (financing_id)
  REFERENCES financing_statement(financing_id)
;
ALTER TABLE general_collateral
  ADD CONSTRAINT gc_reg_id_end_fk FOREIGN KEY (registration_id_end)
  REFERENCES registration(registration_id)
;

-- PK search_id_seq.nextval
CREATE TABLE SEARCH_CLIENT
(
--search_id            NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  search_id            NUMBER NOT NULL,
  SEARCH_TS            DATE,
  SEARCH_TYPE_CD       CHAR(2 BYTE),
  CRITERIA             VARCHAR2(150 BYTE),
  API_CRITERIA         VARCHAR2(1000),
  SEARCH_RESPONSE      CLOB,
  ACCOUNT_ID           VARCHAR2(20 BYTE),
  CLIENT_REFERENCE_ID  VARCHAR2(20 BYTE),
  TOTAL_RESULTS_SIZE   INTEGER,
  RETURNED_RESULTS_SIZE INTEGER,
  PAY_INVOICE_ID       NUMBER,
  PAY_PATH             VARCHAR2(256 BYTE)
 )
;
ALTER TABLE SEARCH_CLIENT
  ADD CONSTRAINT search_client_pk PRIMARY KEY (search_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE SEARCH_CLIENT
  ADD CONSTRAINT search_type_fk FOREIGN KEY (search_type_cd)
  REFERENCES search_type(search_type_cd)
;
CREATE INDEX search_timestamp_index ON SEARCH_CLIENT(search_ts)
      TABLESPACE PPR_INDEX
;


-- PK search_id_seq.nextval
CREATE TABLE SEARCH_RESULT
(
--search_id            NUMBER GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
  SEARCH_ID            NUMBER NOT NULL,
  API_RESULT           CLOB,
  REGISTRATIONS        CLOB,
  JARO                 NUMBER,
  MATCH                CHAR(1 BYTE),
  RESULT_ID            NUMBER,
  RESULT               VARCHAR2(150 BYTE)
 )
;
COMMENT ON COLUMN SEARCH_RESULT.MATCH IS 'required for IMS';
COMMENT ON COLUMN SEARCH_RESULT.RESULT_ID IS 'required for IMS';
COMMENT ON COLUMN SEARCH_RESULT.RESULT IS 'required for IMS';
COMMENT ON COLUMN SEARCH_RESULT.RESULTS IS 'Stores client search selection as JSON.';
COMMENT ON COLUMN SEARCH_RESULT.REGISTRATIONS IS 'Stores search financing_statement results as JSON.';
ALTER TABLE SEARCH_RESULT
  ADD CONSTRAINT search_result_pk PRIMARY KEY (search_id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE SEARCH_RESULT
  ADD CONSTRAINT search_client_fk FOREIGN KEY (search_id)
  REFERENCES search_client(search_id)
;

-- Tables below not used directly by the API
CREATE TABLE THESAURUS
(
  WORD     VARCHAR2(40 BYTE),
  WORD_ID  NUMBER
)
;

CREATE TABLE JARO
(
  JARO_VALUE NUMBER,
  WORD_ID    NUMBER
)
;

CREATE TABLE NICKNAME_PPR
(
  NAME_ID  INTEGER NOT NULL,
  NAME     VARCHAR2(25 BYTE)
)
;

CREATE TABLE USER_INFO
(
  USER_ID           VARCHAR2(8 BYTE)            NOT NULL,
  ACCESS_TYPE       VARCHAR2(1 BYTE),
  NAME_1            VARCHAR2(150 BYTE),
  NAME_2            VARCHAR2(150 BYTE),
  ADDRESS           VARCHAR2(30 BYTE),
  CITY              VARCHAR2(40 BYTE),
  PROVINCE          VARCHAR2(4 BYTE),
  POSTAL_CD         VARCHAR2(15 BYTE),
  BC_ONLINE_NUMBER  NUMBER,
  AREA_CODE         VARCHAR2(3 BYTE),
  PHONE_NUMBER      VARCHAR2(7 BYTE)
)
;

CREATE UNIQUE INDEX USER_ID_KEY ON USER_INFO
(USER_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;

CREATE TABLE NO_RESULT
(
  NIL  CHAR(1 BYTE)
)
;


-- PK user_id_seq.nextval
CREATE TABLE USERS
(
  ID                        NUMBER NOT NULL,
  CREATION_DATE             DATE NOT NULL,
  USERNAME                  VARCHAR2(1000 BYTE) NOT NULL,
  SUB                       VARCHAR2(36 BYTE) NOT NULL,
  ISS                       VARCHAR2(1024 BYTE) NULL,
  FIRSTNAME                 VARCHAR2(1000 BYTE) NULL,
  LASTNAME                  VARCHAR2(1000 BYTE) NULL,
  EMAIL                     VARCHAR2(1024 BYTE) NULL,
  ACCOUNT_ID                VARCHAR2(20 BYTE) NULL
 )
;
ALTER TABLE USERS
  ADD CONSTRAINT users_pk PRIMARY KEY (id)
  USING INDEX
  TABLESPACE PPR_INDEX
;
ALTER TABLE USERS
  ADD CONSTRAINT users_sub_unique UNIQUE(SUB)
;
CREATE INDEX users_username_index ON USERS(USERNAME)
      TABLESPACE PPR_INDEX
;
COMMENT ON TABLE USERS IS 'API only user profile required by UI. Table USER_INFO is legacy only.';

-- PK ID always USERS.ID
CREATE TABLE USER_PROFILE
(
  ID                            NUMBER NOT NULL,
  PAYMENT_CONFIRMATION          CHAR(1 BYTE) DEFAULT 'Y' NOT NULL CHECK(PAYMENT_CONFIRMATION IN ('Y', 'N')),
  SEARCH_SELECTION_CONFIRMATION CHAR(1 BYTE) DEFAULT 'Y' NOT NULL CHECK(SEARCH_SELECTION_CONFIRMATION IN ('Y', 'N')),
  DEFAULT_DROP_DOWNS            CHAR(1 BYTE) DEFAULT 'Y' NOT NULL CHECK(DEFAULT_DROP_DOWNS IN ('Y', 'N')),
  DEFAULT_TABLE_FILTERS         CHAR(1 BYTE) DEFAULT 'Y' NOT NULL CHECK(DEFAULT_TABLE_FILTERS IN ('Y', 'N'))
 )
;
ALTER TABLE USER_PROFILE
  ADD CONSTRAINT user_profile_pk PRIMARY KEY (id)
  using index
  tablespace PPR_INDEX
;
ALTER TABLE USER_PROFILE
  ADD CONSTRAINT user_profile_users_fk FOREIGN KEY (id)
  REFERENCES USERS(id)
;

COMMENT ON COLUMN USER_PROFILE.PAYMENT_CONFIRMATION IS 'Y (default) if payment confirmation dialog is enabled for the user.';
COMMENT ON COLUMN USER_PROFILE.SEARCH_SELECTION_CONFIRMATION IS 'Y (default) if search selection confirmation dialog is enabled for the user.';
