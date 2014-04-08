CREATE TABLE [dbo].[ServiceLineCategory] (
    [SERVICE_LINE_CATEGORY_ID] INT           IDENTITY (1, 1) NOT NULL,
    [CATEGORY]                 VARCHAR (100) NOT NULL,
    [CREATE_DATE]              DATETIME      CONSTRAINT [DF_ServiceLineCategory_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]       INT           NOT NULL,
    [UPDATE_DATE]              DATETIME      NULL,
    [UPDATED_BY_USER_ID]       INT           NULL,
    CONSTRAINT [PK_ServiceLineCategory] PRIMARY KEY CLUSTERED ([SERVICE_LINE_CATEGORY_ID] ASC),
    CONSTRAINT [FK_ServiceLineCategory_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ServiceLineCategory_PdtsUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

