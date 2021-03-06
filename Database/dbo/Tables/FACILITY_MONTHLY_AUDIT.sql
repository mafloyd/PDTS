﻿CREATE TABLE [dbo].[FACILITY_MONTHLY_AUDIT] (
    [FACILITY_AUDIT_ID]  INT            IDENTITY (1, 1) NOT NULL,
    [COID]               VARCHAR (5)    NOT NULL,
    [AUDIT_ID]           INT            NOT NULL,
    [MONTH]              INT            NOT NULL,
    [YEAR]               INT            NOT NULL,
    [VALIDATED]          BIT            CONSTRAINT [DF_FACILITY_AUDIT_POST_VALIDATED_1] DEFAULT ((0)) NOT NULL,
    [VALIDATE_USER_ID]   INT            NULL,
    [VALIDATE_USER_DATE] DATETIME       NULL,
    [VALIDATE_USER_NAME] VARCHAR (50)   NULL,
    [REVIEWED]           BIT            CONSTRAINT [DF_FACILITY_AUDIT_POST_REVIEWED_1] DEFAULT ((0)) NOT NULL,
    [REVIEWED_USER_ID]   INT            NULL,
    [REVIEWED_USER_DATE] DATETIME       NULL,
    [REVIEWED_USER_NAME] VARCHAR (50)   NULL,
    [CREATE_DATE]        DATETIME       CONSTRAINT [DF_FACILITY_MONTHLY_AUDIT_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [COMMENT]            VARCHAR (1000) NULL,
    [COMMENT_USER_ID]    INT            NULL,
    [COMMENT_USER_NAME]  VARCHAR (50)   NULL,
    [COMMENT_DATE]       DATETIME       NULL,
    [COMMENT_VALIDATED]  BIT            CONSTRAINT [DF_FACILITY_AUDIT_POST_COMMENT_VALIDATED_1] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_FACILITY_AUDIT_POST] PRIMARY KEY CLUSTERED ([FACILITY_AUDIT_ID] ASC),
    CONSTRAINT [FK_FACILITY_AUDIT_POST_MASTER_AUDIT] FOREIGN KEY ([AUDIT_ID]) REFERENCES [dbo].[MASTER_AUDIT] ([AUDIT_ID]),
    CONSTRAINT [FK_FACILITY_MONTHLY_AUDIT_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID])
);

