﻿CREATE TABLE [dbo].[ER_DAILY_ENTRY_HISTORY] (
    [ER_DAILY_ENTRY_ID]            INT             NOT NULL,
    [ER_DAILY_STATS_DEFINITION_ID] INT             NOT NULL,
    [COID]                         VARCHAR (5)     NOT NULL,
    [YEAR]                         INT             NOT NULL,
    [MONTH]                        INT             NOT NULL,
    [DAY_1]                        DECIMAL (10, 2) NOT NULL,
    [DAY_2]                        DECIMAL (10, 2) NOT NULL,
    [DAY_3]                        DECIMAL (10, 2) NOT NULL,
    [DAY_4]                        DECIMAL (10, 2) NOT NULL,
    [DAY_5]                        DECIMAL (10, 2) NOT NULL,
    [DAY_6]                        DECIMAL (10, 2) NOT NULL,
    [DAY_7]                        DECIMAL (10, 2) NOT NULL,
    [DAY_8]                        DECIMAL (10, 2) NOT NULL,
    [DAY_9]                        DECIMAL (10, 2) NOT NULL,
    [DAY_10]                       DECIMAL (10, 2) NOT NULL,
    [DAY_11]                       DECIMAL (10, 2) NOT NULL,
    [DAY_12]                       DECIMAL (10, 2) NOT NULL,
    [DAY_13]                       DECIMAL (10, 2) NOT NULL,
    [DAY_14]                       DECIMAL (10, 2) NOT NULL,
    [DAY_15]                       DECIMAL (10, 2) NOT NULL,
    [DAY_16]                       DECIMAL (10, 2) NOT NULL,
    [DAY_17]                       DECIMAL (10, 2) NOT NULL,
    [DAY_18]                       DECIMAL (10, 2) NOT NULL,
    [DAY_19]                       DECIMAL (10, 2) NOT NULL,
    [DAY_20]                       DECIMAL (10, 2) NOT NULL,
    [DAY_21]                       DECIMAL (10, 2) NOT NULL,
    [DAY_22]                       DECIMAL (10, 2) NOT NULL,
    [DAY_23]                       DECIMAL (10, 2) NOT NULL,
    [DAY_24]                       DECIMAL (10, 2) NOT NULL,
    [DAY_25]                       DECIMAL (10, 2) NOT NULL,
    [DAY_26]                       DECIMAL (10, 2) NOT NULL,
    [DAY_27]                       DECIMAL (10, 2) NOT NULL,
    [DAY_28]                       DECIMAL (10, 2) NOT NULL,
    [DAY_29]                       DECIMAL (10, 2) NOT NULL,
    [DAY_30]                       DECIMAL (10, 2) NOT NULL,
    [DAY_31]                       DECIMAL (10, 2) NOT NULL,
    [CREATE_DATE]                  DATETIME        NOT NULL,
    [CREATED_BY_USER_ID]           INT             NOT NULL,
    [UPDATE_DATE]                  DATETIME        NULL,
    [UPDATED_BY_USER_ID]           INT             NULL,
    [RECORD_START_DATE]            DATETIME        NOT NULL,
    [RECORD_END_DATE]              DATETIME        NULL,
    [TOTAL]                        DECIMAL (10, 2) NULL,
    [AVERAGE]                      DECIMAL (10, 2) NULL
);
