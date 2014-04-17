CREATE TABLE [dbo].[ServiceMasterInventory] (
    [SERVICE_MASTER_INVENTORY_ID] INT           NOT NULL,
    [NAME]                        VARCHAR (100) NOT NULL,
    [DEFINITION]                  VARCHAR (250) NULL,
    [SERVICE_LINE_CATEGORY_ID]    INT           NOT NULL,
    [SERVICE_LINE_AREA_ID]        INT           NOT NULL,
    [CREATE_DATE]                 DATETIME      CONSTRAINT [DF_ServiceMasterInventory_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]          INT           NOT NULL,
    [UPDATE_DATE]                 DATETIME      NULL,
    [UPDATED_BY_USER_ID]          INT           NULL,
    CONSTRAINT [PK_ServiceMasterInventory] PRIMARY KEY CLUSTERED ([SERVICE_MASTER_INVENTORY_ID] ASC),
    CONSTRAINT [FK_ServiceMasterInventory_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ServiceMasterInventory_ServiceLineArea] FOREIGN KEY ([SERVICE_LINE_AREA_ID]) REFERENCES [dbo].[ServiceLineArea] ([SERVICE_LINE_AREA_ID]),
    CONSTRAINT [FK_ServiceMasterInventory_ServiceLineCategory] FOREIGN KEY ([SERVICE_LINE_CATEGORY_ID]) REFERENCES [dbo].[ServiceLineCategory] ([SERVICE_LINE_CATEGORY_ID]),
    CONSTRAINT [FK_ServiceMasterInventory_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

