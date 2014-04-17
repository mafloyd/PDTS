CREATE TABLE [dbo].[ig_Extensions] (
    [EXTENSION_ID]        INT             IDENTITY (1, 1) NOT NULL,
    [WORKSHEET_ID]        INT             NULL,
    [EXTENSION_NO]        INT             NULL,
    [EXT_MONTHLY_AMT]     DECIMAL (11, 2) NULL,
    [EXT_MONTHS]          INT             NULL,
    [EXT_TOTAL_AMT]       DECIMAL (11, 2) NULL,
    [EXT_TOTAL_FASB]      DECIMAL (11, 2) NULL,
    [EXT_START_DATE]      DATETIME        NULL,
    [EXT_COMPLETION_DATE] DATETIME        NULL,
    [CREATED_DATE]        DATETIME        NULL,
    [CREATED_BY]          INT             NULL,
    CONSTRAINT [PK_igExtensions] PRIMARY KEY CLUSTERED ([EXTENSION_ID] ASC)
);

