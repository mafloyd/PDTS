CREATE TABLE [dbo].[OperationalInitiativeStatus] (
    [OPERATIONAL_INITIATIVE_STATUS_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                             VARCHAR (50) NOT NULL,
    [CREATE_DATE]                      DATETIME     CONSTRAINT [DF_OperationalInitiativeStatus_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]               INT          NOT NULL,
    [UPDATE_DATE]                      DATETIME     NULL,
    [UPDATED_BY_USER_ID]               INT          NULL,
    CONSTRAINT [PK_OperationalInitiativeStatus] PRIMARY KEY CLUSTERED ([OPERATIONAL_INITIATIVE_STATUS_ID] ASC),
    CONSTRAINT [FK_OperationalInitiativeStatus_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_OperationalInitiativeStatus_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

