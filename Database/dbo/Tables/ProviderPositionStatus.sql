CREATE TABLE [dbo].[ProviderPositionStatus] (
    [PROVIDER_POSITION_STATUS_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                        VARCHAR (50) NOT NULL,
    [CREATE_DATE]                 DATETIME     CONSTRAINT [DF_Budget_Type_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]          INT          NOT NULL,
    [UPDATE_DATE]                 DATETIME     NULL,
    [UPDATED_BY_USER_ID]          INT          NULL,
    CONSTRAINT [PK_Budget_Type] PRIMARY KEY CLUSTERED ([PROVIDER_POSITION_STATUS_ID] ASC),
    CONSTRAINT [FK_Budget_Type_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_Budget_Type_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

