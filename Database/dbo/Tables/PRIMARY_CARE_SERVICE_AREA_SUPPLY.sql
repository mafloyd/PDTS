﻿CREATE TABLE [dbo].[PRIMARY_CARE_SERVICE_AREA_SUPPLY] (
    [PRIMARY_SERVICE_AREA_SUPPLY_ID]       INT            IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]                     INT            NULL,
    [COID]                                 VARCHAR (5)    NULL,
    [PROVIDER_NAME]                        VARCHAR (150)  NULL,
    [SPECIALTY]                            VARCHAR (100)  NULL,
    [BIRTH_DATE]                           DATETIME       NULL,
    [GROUP_NAME]                           VARCHAR (150)  NULL,
    [NOTE]                                 VARCHAR (1000) NULL,
    [PRIMARY_CARE_AFFILIATION_ID]          INT            NULL,
    [INCLUDE_EXISTING_MSD_INFO]            BIT            CONSTRAINT [DF_PRIMARY_SERVICE_AREA_SUPPLY_INCLUDE_EXISTING_MSD_INFO] DEFAULT ((0)) NULL,
    [STRATEGIC_IMPORTANCE_ID]              INT            NULL,
    [SUPPORT_LOCAL_SPECIALISTS_ID]         INT            NULL,
    [CULTURAL_COMPATABILITY_ID]            INT            NULL,
    [EMPLOYMENT_POTENTIAL_ID]              INT            NULL,
    [RECIPITIVITY_ID]                      INT            NULL,
    [LIKELY_TO_REMAIN_IN_MARKET_10_ID]     INT            NULL,
    [PRACTICE_CAPACITY_ID]                 INT            NULL,
    [RISK_PROFILE_SCORE]                   DECIMAL (3, 2) NULL,
    [COMMUNITY_FTE_ASSESSMENT]             DECIMAL (3, 2) NULL,
    [PRIMARY_CARE_SERVICE_AREA_ID]         INT            NULL,
    [PRIMARY_CARE_COMMUNITY_ACCEPTANCE_ID] INT            NULL,
    [PRIMARY_CARE_OTHER_RISK_ID]           INT            NULL,
    [PRIMARY_CARE_PRACTICE_REVENUE_ID]     INT            NULL,
    [PRIMARY_CARE_YEARS_IN_PRACTICE_ID]    INT            NULL,
    [AGE_RISK]                             INT            NULL,
    [COMMUNITY_ACCEPTANCE_RISK]            INT            NULL,
    [OTHER_RISK]                           INT            NULL,
    [PRACTICE_REVENUES_RISK]               INT            NULL,
    [YEARS_IN_PRACTICE_RISK]               INT            NULL,
    [HIGH_RISK_FLAG]                       BIT            CONSTRAINT [DF_PRIMARY_CARE_SERVICE_AREA_SUPPLY_HIGH_RISK_FLAG] DEFAULT ((0)) NOT NULL,
    [LOST_PHYSICIANS_FTE]                  INT            NULL,
    [NP_SUPPLY]                            INT            CONSTRAINT [DF_PRIMARY_CARE_SERVICE_AREA_SUPPLY_PN_SUPPLY] DEFAULT ((0)) NULL,
    [AGE]                                  DECIMAL (5, 2) NULL,
    [CREATE_DATE]                          DATETIME       CONSTRAINT [DF_PRIMARY_CARE_SERVICE_AREA_SUPPLY_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]                   INT            NOT NULL,
    [UPDATE_DATE]                          DATETIME       NULL,
    [UPDATED_BY_USER_ID]                   INT            NULL,
    CONSTRAINT [PK_PRIMARY_SERVICE_AREA_SUPPLY_1] PRIMARY KEY CLUSTERED ([PRIMARY_SERVICE_AREA_SUPPLY_ID] ASC),
    CONSTRAINT [FK_PRIMARY_CARE_SERVICE_AREA_SUPPLY_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_PRIMARY_CARE_SERVICE_AREA_SUPPLY_PRIMARY_CARE_COMMUNITY_ACCEPTANCE] FOREIGN KEY ([PRIMARY_CARE_COMMUNITY_ACCEPTANCE_ID]) REFERENCES [dbo].[PRIMARY_CARE_COMMUNITY_ACCEPTANCE] ([PRIMARY_CARE_COMMUNITY_ACCEPTANCE_ID]),
    CONSTRAINT [FK_PRIMARY_CARE_SERVICE_AREA_SUPPLY_PRIMARY_CARE_OTHER_RISK] FOREIGN KEY ([PRIMARY_CARE_OTHER_RISK_ID]) REFERENCES [dbo].[PRIMARY_CARE_OTHER_RISK] ([PRIMARY_CARE_OTHER_RISK_ID]),
    CONSTRAINT [FK_PRIMARY_CARE_SERVICE_AREA_SUPPLY_PRIMARY_CARE_PRACTICE_REVENUE] FOREIGN KEY ([PRIMARY_CARE_PRACTICE_REVENUE_ID]) REFERENCES [dbo].[PRIMARY_CARE_PRACTICE_REVENUE] ([PRIMARY_CARE_PRACTICE_REVENUE_ID]),
    CONSTRAINT [FK_PRIMARY_CARE_SERVICE_AREA_SUPPLY_PRIMARY_CARE_SERVICE_AREA] FOREIGN KEY ([PRIMARY_CARE_SERVICE_AREA_ID]) REFERENCES [dbo].[PRIMARY_CARE_SERVICE_AREA] ([PRIMARY_CARE_SERVICE_AREA_ID]),
    CONSTRAINT [FK_PRIMARY_CARE_SERVICE_AREA_SUPPLY_PRIMARY_CARE_YEARS_IN_PRACTICE] FOREIGN KEY ([PRIMARY_CARE_YEARS_IN_PRACTICE_ID]) REFERENCES [dbo].[PRIMARY_CARE_YEARS_IN_PRACTICE] ([PRIMARY_CARE_YEARS_IN_PRACTICE_ID]),
    CONSTRAINT [FK_PRIMARY_CARE_SERVICE_AREA_SUPPLY_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_PRIMARY_SERVICE_AREA_SUPPLY_PRIMARY_CARE_AFFILIATION] FOREIGN KEY ([PRIMARY_CARE_AFFILIATION_ID]) REFERENCES [dbo].[PRIMARY_CARE_AFFILIATION] ([PRIMARY_CARE_AFFILIATION_ID]),
    CONSTRAINT [FK_PRIMARY_SERVICE_AREA_SUPPLY_PRIMARY_CARE_RANKING] FOREIGN KEY ([LIKELY_TO_REMAIN_IN_MARKET_10_ID]) REFERENCES [dbo].[PRIMARY_CARE_RANKING] ([PRIMARY_CARE_RANKING_ID]),
    CONSTRAINT [FK_PRIMARY_SERVICE_AREA_SUPPLY_PRIMARY_CARE_RANKING1] FOREIGN KEY ([STRATEGIC_IMPORTANCE_ID]) REFERENCES [dbo].[PRIMARY_CARE_RANKING] ([PRIMARY_CARE_RANKING_ID]),
    CONSTRAINT [FK_PRIMARY_SERVICE_AREA_SUPPLY_PRIMARY_CARE_RANKING2] FOREIGN KEY ([SUPPORT_LOCAL_SPECIALISTS_ID]) REFERENCES [dbo].[PRIMARY_CARE_RANKING] ([PRIMARY_CARE_RANKING_ID]),
    CONSTRAINT [FK_PRIMARY_SERVICE_AREA_SUPPLY_PRIMARY_CARE_RANKING3] FOREIGN KEY ([CULTURAL_COMPATABILITY_ID]) REFERENCES [dbo].[PRIMARY_CARE_RANKING] ([PRIMARY_CARE_RANKING_ID]),
    CONSTRAINT [FK_PRIMARY_SERVICE_AREA_SUPPLY_PRIMARY_CARE_RANKING4] FOREIGN KEY ([EMPLOYMENT_POTENTIAL_ID]) REFERENCES [dbo].[PRIMARY_CARE_RANKING] ([PRIMARY_CARE_RANKING_ID]),
    CONSTRAINT [FK_PRIMARY_SERVICE_AREA_SUPPLY_PRIMARY_CARE_RANKING5] FOREIGN KEY ([RECIPITIVITY_ID]) REFERENCES [dbo].[PRIMARY_CARE_RANKING] ([PRIMARY_CARE_RANKING_ID]),
    CONSTRAINT [FK_PRIMARY_SERVICE_AREA_SUPPLY_PRIMARY_CARE_RANKING6] FOREIGN KEY ([PRACTICE_CAPACITY_ID]) REFERENCES [dbo].[PRIMARY_CARE_RANKING] ([PRIMARY_CARE_RANKING_ID])
);

