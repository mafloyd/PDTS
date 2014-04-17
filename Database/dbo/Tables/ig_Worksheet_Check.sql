CREATE TABLE [dbo].[ig_Worksheet_Check] (
    [IG_WORKSHEET_CHECK_D]   INT             IDENTITY (1, 1) NOT NULL,
    [WORKSHEET_ID]           INT             NOT NULL,
    [ADVPD_CHECK_DATE]       DATETIME        NOT NULL,
    [ADVPD_CHECK_NUMBER]     INT             NOT NULL,
    [ADVPD_CEO_CFO_INITIALS] VARCHAR (50)    NOT NULL,
    [CREATE_DATE]            DATETIME        CONSTRAINT [DF_ig_Worksheet_Check_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]     INT             NOT NULL,
    [UPDATE_DATE]            DATETIME        NULL,
    [UPDATED_BY_USER_ID]     INT             NULL,
    [AMOUNT]                 DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_Check_AMOUNT] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ig_Worksheet_Check] PRIMARY KEY CLUSTERED ([IG_WORKSHEET_CHECK_D] ASC),
    CONSTRAINT [FK_ig_Worksheet_Check_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ig_Worksheet_Check_ig_Worksheets] FOREIGN KEY ([WORKSHEET_ID]) REFERENCES [dbo].[ig_Worksheets] ([WORKSHEET_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_ig_Worksheet_Check_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

