CREATE TABLE [dbo].[ig_Worksheet_Practice_Managment_Allowance] (
    [PRACTICE_MANAGEMENT_ALLOWANCE_ID] INT             IDENTITY (1, 1) NOT NULL,
    [WORKSHEET_ID]                     INT             NOT NULL,
    [ALLOWANCE_DATE]                   DATETIME        NOT NULL,
    [ALLOWANCE_AMOUNT]                 DECIMAL (11, 2) NOT NULL,
    [CREATE_DATE]                      DATETIME        CONSTRAINT [DF_ig_Worksheet_Practice_Managment_Allowance_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]               INT             NOT NULL,
    [UPDATE_DATE]                      DATETIME        NULL,
    [UPDATED_BY_USER_ID]               INT             NULL,
    CONSTRAINT [PK_ig_Worksheet_Practice_Managment_Allowance] PRIMARY KEY CLUSTERED ([PRACTICE_MANAGEMENT_ALLOWANCE_ID] ASC),
    CONSTRAINT [FK_ig_Worksheet_Practice_Managment_Allowance_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ig_Worksheet_Practice_Managment_Allowance_ig_Worksheets] FOREIGN KEY ([WORKSHEET_ID]) REFERENCES [dbo].[ig_Worksheets] ([WORKSHEET_ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_ig_Worksheet_Practice_Managment_Allowance_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

