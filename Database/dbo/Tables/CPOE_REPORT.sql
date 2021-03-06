﻿CREATE TABLE [dbo].[CPOE_REPORT] (
    [CPOE_ID]       INT           IDENTITY (1, 1) NOT NULL,
    [COID]          VARCHAR (5)   NOT NULL,
    [NPI]           DECIMAL (10)  NULL,
    [PROVIDER_NAME] VARCHAR (150) NULL,
    [NUMERATOR]     INT           CONSTRAINT [DF_CPOE_REPORT_NUMERATOR] DEFAULT ((0)) NOT NULL,
    [DENOMINATOR]   INT           CONSTRAINT [DF_CPOE_REPORT_DENOMINATOR] DEFAULT ((0)) NOT NULL,
    [CPOE_DATE]     DATETIME      NOT NULL,
    CONSTRAINT [PK_CPOE_REPORT] PRIMARY KEY CLUSTERED ([CPOE_ID] ASC)
);

