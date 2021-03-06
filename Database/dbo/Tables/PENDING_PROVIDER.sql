﻿CREATE TABLE [dbo].[PENDING_PROVIDER] (
    [PENDING_PROVIDER_ID]                INT            IDENTITY (1, 1) NOT NULL,
    [COID]                               VARCHAR (5)    NOT NULL,
    [FIRST_NAME]                         VARCHAR (50)   NULL,
    [MIDDLE_NAME]                        VARCHAR (50)   NULL,
    [LAST_NAME]                          VARCHAR (50)   NOT NULL,
    [PROVIDER_TITLE_ID]                  INT            NULL,
    [START_DATE]                         DATETIME       NULL,
    [NPI]                                BIGINT         NULL,
    [NPPES_LOGIN]                        VARCHAR (50)   NULL,
    [NPPES_PASSWORD]                     VARCHAR (50)   NULL,
    [GROUP_NPI]                          BIGINT         NULL,
    [SSN]                                VARCHAR (11)   NULL,
    [DEA_NUMBER]                         VARCHAR (20)   NULL,
    [DOB]                                DATETIME       NULL,
    [EMPLOYEE_PHYSICIAN_COID]            VARCHAR (5)    NULL,
    [PROVIDER_DEPT_ID]                   INT            NULL,
    [PROVIDER_OVERHEAD_DEPT_ID]          INT            NULL,
    [SPECIALTY_ID]                       INT            NULL,
    [PROVIDER_TYPE_ID]                   INT            NULL,
    [FTE_ASSESSMENT]                     DECIMAL (2, 1) NULL,
    [CONTRACT_LENGTH]                    INT            NULL,
    [TERM_DATE]                          DATETIME       NULL,
    [SALARY]                             MONEY          NULL,
    [JOINING_AN_EXISTING_PRACTICE]       BIT            CONSTRAINT [DF_PENDING_PROVIDER_JOINING_AN_EXISTING_PRACTICE] DEFAULT ((0)) NOT NULL,
    [REPLACING_AN_EXISTING_PROVIDER]     BIT            CONSTRAINT [DF_PENDING_PROVIDER_REPLACING_AN_EXISTING_PROVIDER] DEFAULT ((0)) NOT NULL,
    [PROVIDER_BEING_REPLACED]            VARCHAR (100)  NULL,
    [PRIOR_MALPRACTICE_COVERAGE_AMOUNT]  MONEY          NULL,
    [PRIOR_MALPRACTICE_COVERAGE_CARRIER] VARCHAR (100)  NULL,
    [BUDGETED]                           BIT            CONSTRAINT [DF_PENDING_PROVIDER_BUDGETED] DEFAULT ((0)) NOT NULL,
    [PROVIDER_PRACTICE_ID]               INT            NULL,
    [REGIONAL_DIRECTOR_ID]               INT            NULL,
    [APPROVED]                           BIT            CONSTRAINT [DF_PENDING_PROVIDER_APPROVED] DEFAULT ((0)) NOT NULL,
    [APPROVED_BY_USER_ID]                INT            NULL,
    [APPROVED_DATE]                      DATETIME       NULL,
    [CREATE_DATE]                        DATETIME       CONSTRAINT [DF_PENDING_PROVIDER_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]                 INT            NOT NULL,
    [LEFT_DATE]                          DATETIME       NULL,
    [PROVIDER_LINE_OF_BUSINESS_ID]       INT            NULL,
    [EMPLOYED_PROVIDER_STATUS_ID]        INT            CONSTRAINT [DF_PENDING_PROVIDER_EMPLOYED_PROVIDER_STATUS_ID] DEFAULT ((3)) NOT NULL,
    [IS_PROCESSED]                       BIT            CONSTRAINT [DF_PENDING_PROVIDER_IS_PROCESSED] DEFAULT ((0)) NOT NULL,
    [PROCESSED_DATE]                     DATETIME       NULL,
    [PROVIDER_SENIOR_DIRECTOR_ID]        INT            NOT NULL,
    CONSTRAINT [PK_PENDING_PROVIDER] PRIMARY KEY CLUSTERED ([PENDING_PROVIDER_ID] ASC),
    CONSTRAINT [FK_PENDING_PROVIDER_EMPLOYED_PROVIDER_STATUS] FOREIGN KEY ([EMPLOYED_PROVIDER_STATUS_ID]) REFERENCES [dbo].[EMPLOYED_PROVIDER_STATUS] ([EMPLOYED_PROVIDER_STATUS_ID]),
    CONSTRAINT [FK_PENDING_PROVIDER_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_PENDING_PROVIDER_PdtsUser] FOREIGN KEY ([APPROVED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_PENDING_PROVIDER_PdtsUser1] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_PENDING_PROVIDER_PENDING_PROVIDER] FOREIGN KEY ([PENDING_PROVIDER_ID]) REFERENCES [dbo].[PENDING_PROVIDER] ([PENDING_PROVIDER_ID]),
    CONSTRAINT [FK_PENDING_PROVIDER_PROVIDER_LINE_OF_BUSINESS] FOREIGN KEY ([PROVIDER_LINE_OF_BUSINESS_ID]) REFERENCES [dbo].[PROVIDER_LINE_OF_BUSINESS] ([PROVIDER_LINE_OF_BUSINESS_ID]),
    CONSTRAINT [FK_PENDING_PROVIDER_PROVIDER_TYPE] FOREIGN KEY ([PROVIDER_TYPE_ID]) REFERENCES [dbo].[PROVIDER_TYPE] ([PROVIDER_TYPE_ID]),
    CONSTRAINT [FK_PENDING_PROVIDER_ProviderDepartment] FOREIGN KEY ([PROVIDER_DEPT_ID]) REFERENCES [dbo].[ProviderDepartment] ([PROVIDER_DEPT_ID]),
    CONSTRAINT [FK_PENDING_PROVIDER_ProviderOverheadDepartment] FOREIGN KEY ([PROVIDER_OVERHEAD_DEPT_ID]) REFERENCES [dbo].[ProviderOverheadDepartment] ([PROVIDER_OVERHEAD_DEPT_ID]),
    CONSTRAINT [FK_PENDING_PROVIDER_ProviderRegionalDirector] FOREIGN KEY ([REGIONAL_DIRECTOR_ID]) REFERENCES [dbo].[ProviderRegionalDirector] ([PROVIDER_REGIONAL_DIRECTOR_ID]),
    CONSTRAINT [FK_PENDING_PROVIDER_ProviderSeniorDirector] FOREIGN KEY ([PROVIDER_SENIOR_DIRECTOR_ID]) REFERENCES [dbo].[ProviderSeniorDirector] ([PROVIDER_SENIOR_DIRECTOR_ID]),
    CONSTRAINT [FK_PENDING_PROVIDER_ProviderTitle] FOREIGN KEY ([PROVIDER_TITLE_ID]) REFERENCES [dbo].[ProviderTitle] ([PROVIDER_TITLE_ID]),
    CONSTRAINT [FK_PENDING_PROVIDER_Specialty] FOREIGN KEY ([SPECIALTY_ID]) REFERENCES [dbo].[Specialty] ([SPECIALTY_ID])
);

