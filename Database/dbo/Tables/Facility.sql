﻿CREATE TABLE [dbo].[Facility] (
    [COID]                           VARCHAR (5)  NOT NULL,
    [FAC]                            VARCHAR (5)  NULL,
    [UNIT]                           VARCHAR (5)  NULL,
    [NAME]                           VARCHAR (50) NULL,
    [SHORT_NAME]                     VARCHAR (50) NULL,
    [CLS_NAME]                       VARCHAR (50) NULL,
    [FACILITY_NAME]                  VARCHAR (50) NULL,
    [DIVISION_ID]                    INT          NULL,
    [COMPANY_ID]                     INT          NULL,
    [CATEGORY_ID]                    INT          NULL,
    [STATE_ID]                       INT          NULL,
    [COGROUP_ID]                     INT          NULL,
    [ACTIVE]                         BIT          CONSTRAINT [DF_Facility_ACTIVE] DEFAULT ((1)) NOT NULL,
    [CREATE_DATE]                    DATETIME     CONSTRAINT [DF_Facility_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]             INT          NOT NULL,
    [UPDATE_DATE]                    DATETIME     NULL,
    [UPDATED_BY_USER_ID]             INT          NULL,
    [SAME_STORE]                     BIT          CONSTRAINT [DF_Facility_SAME_STORE] DEFAULT ((0)) NOT NULL,
    [TOP_TEN]                        BIT          CONSTRAINT [DF_Facility_TOP_TEN] DEFAULT ((0)) NOT NULL,
    [TOP_TEN_SORT_ORDER]             INT          CONSTRAINT [DF_Facility_TOP_TEN_SORT_ORDER] DEFAULT ((0)) NOT NULL,
    [SHOW_IN_DETAIL_REPORTS]         BIT          CONSTRAINT [DF_Facility_SHOW_IN_DETAIL_REPORTS] DEFAULT ((1)) NOT NULL,
    [EDM_MANAGING_COMPANY_ID]        INT          NULL,
    [ED_TIER_RANKING_ID]             INT          NULL,
    [NEW_STORE]                      BIT          CONSTRAINT [DF_Facility_NEW_STORE] DEFAULT ((0)) NULL,
    [GROUP_COID]                     VARCHAR (5)  NOT NULL,
    [INCLUDE_IN_FLASH_TOTALS]        BIT          CONSTRAINT [DF_Facility_INCLUDE_IN_FLASH_TOTALS] DEFAULT ((1)) NOT NULL,
    [BUDGET_EQUAL_RUNRATE_WHEN_ZERO] BIT          CONSTRAINT [DF_Facility_BUDGET_EQUAL_RUNRATE_WHEN_ZERO] DEFAULT ((0)) NOT NULL,
    [IS_PRE_CLOSE]                   BIT          CONSTRAINT [DF_Facility_IS_PRE_CLOSE] DEFAULT ((0)) NOT NULL,
    [TOP_TEN_LIST]                   BIT          CONSTRAINT [DF_Facility_TOP_TEN_LIST] DEFAULT ((0)) NOT NULL,
    [INCLUDE_WITH_GROUP]             BIT          CONSTRAINT [DF_Facility_INCLUDE_WITH_GROUP] DEFAULT ((0)) NOT NULL,
    [PCR]                            BIT          CONSTRAINT [DF_Facility_PCR] DEFAULT ((0)) NULL,
    [IS_POST_CLOSE]                  BIT          CONSTRAINT [DF_Facility_IS_POST_CLOSE] DEFAULT ((0)) NOT NULL,
    [PARENT_COID]                    VARCHAR (5)  NULL,
    [FLASH_ROLLUP_TO_COID]           VARCHAR (5)  NULL,
    [EXCLUDE_FROM_ER_DASHBOARD]      BIT          CONSTRAINT [DF_Facility_EXCLUDE_FROM_ER_DASHBOARD] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Facility] PRIMARY KEY CLUSTERED ([COID] ASC)
);

