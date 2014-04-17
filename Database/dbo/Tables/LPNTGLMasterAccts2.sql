﻿CREATE TABLE [dbo].[LPNTGLMasterAccts2] (
    [LPNT_ACCT_CHART2_ID] INT           IDENTITY (1, 1) NOT NULL,
    [LPNTFSCode]          VARCHAR (255) NULL,
    [LPNTFSCodeDesc]      VARCHAR (255) NULL,
    [LPNTAcct]            VARCHAR (50)  NULL,
    [LPNTAcctDesc]        VARCHAR (255) NULL,
    CONSTRAINT [PK_LPNTGLMasterAccts2] PRIMARY KEY CLUSTERED ([LPNT_ACCT_CHART2_ID] ASC)
);
