CREATE TABLE [dbo].[ServiceLineArea] (
    [SERVICE_LINE_AREA_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                 VARCHAR (50) NOT NULL,
    [CREATE_DATE]          DATETIME     CONSTRAINT [DF_ServiceLineArea_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]   INT          NOT NULL,
    [UPDATE_DATE]          DATETIME     NULL,
    [UPDATED_BY_USER_ID]   INT          NULL,
    CONSTRAINT [PK_ServiceLineArea] PRIMARY KEY CLUSTERED ([SERVICE_LINE_AREA_ID] ASC),
    CONSTRAINT [FK_ServiceLineArea_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ServiceLineArea_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

