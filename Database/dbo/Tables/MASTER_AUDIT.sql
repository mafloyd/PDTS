﻿CREATE TABLE [dbo].[MASTER_AUDIT] (
    [AUDIT_ID]           INT           IDENTITY (1, 1) NOT NULL,
    [CONTROL_ID]         INT           NOT NULL,
    [CONTROL]            VARCHAR (500) NOT NULL,
    [ACTIVE]             BIT           CONSTRAINT [DF_MASTER_AUDIT_ACTIVE] DEFAULT ((0)) NOT NULL,
    [CREATE_DATE]        DATETIME      CONSTRAINT [DF_MASTER_AUDIT_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] VARCHAR (20)  NOT NULL,
    [UPDATE_DATE]        DATETIME      NULL,
    [UPDATED_BY_USER_ID] VARCHAR (20)  NULL,
    [PRE]                BIT           CONSTRAINT [DF_MASTER_AUDIT_PRE] DEFAULT ((0)) NOT NULL,
    [POST]               BIT           CONSTRAINT [DF_MASTER_AUDIT_POST] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_MASTER_AUDIT] PRIMARY KEY CLUSTERED ([AUDIT_ID] ASC)
);

