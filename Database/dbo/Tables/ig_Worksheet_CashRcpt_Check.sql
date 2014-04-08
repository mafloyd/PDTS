CREATE TABLE [dbo].[ig_Worksheet_CashRcpt_Check] (
    [IG_WORKSHEET_CASH_RECEIPT_CHECK_ID] INT             IDENTITY (1, 1) NOT NULL,
    [RECEIPT_ID]                         INT             NOT NULL,
    [CHECK_DATE]                         DATETIME        NOT NULL,
    [CHECK_NUMBER]                       INT             NOT NULL,
    [CREATE_DATE]                        DATETIME        CONSTRAINT [DF_ig_Worksheet_CashRcpt_Check_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CEO_CFO_INITIALS]                   VARCHAR (50)    NOT NULL,
    [CREATED_BY_USER_ID]                 INT             NOT NULL,
    [UPDATE_DATE]                        DATETIME        NULL,
    [UPDATED_BY_USER_ID]                 INT             NULL,
    [AMOUNT]                             DECIMAL (11, 2) CONSTRAINT [DF_ig_Worksheet_CashRcpt_Check_AMOUNT] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ig_Worksheet_CashRcpt_Check] PRIMARY KEY CLUSTERED ([IG_WORKSHEET_CASH_RECEIPT_CHECK_ID] ASC),
    CONSTRAINT [FK_ig_Worksheet_CashRcpt_Check_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ig_Worksheet_CashRcpt_Check_ig_Worksheet_CashRcpts] FOREIGN KEY ([RECEIPT_ID]) REFERENCES [dbo].[ig_Worksheet_CashRcpts] ([RECEIPT_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_ig_Worksheet_CashRcpt_Check_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

