CREATE TABLE [dbo].[ServiceFacilityMix] (
    [SERVICE_FACILITY_MIX_ID]     INT         IDENTITY (1, 1) NOT NULL,
    [COID]                        VARCHAR (5) NOT NULL,
    [SERVICE_MASTER_INVENTORY_ID] INT         NOT NULL,
    [CREATE_DATE]                 DATETIME    CONSTRAINT [DF_ServiceFacilityMix_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]          INT         NOT NULL,
    [UPDATE_DATE]                 DATETIME    NULL,
    [UPDATED_BY_USER_ID]          INT         NULL,
    [OFFERED_YES]                 BIT         CONSTRAINT [DF_ServiceFacilityMix_IS_SERVICE_PROVIDED] DEFAULT ((0)) NOT NULL,
    [OFFERED_NO]                  BIT         CONSTRAINT [DF_ServiceFacilityMix_OFFERED_NO] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ServiceFacilityMix] PRIMARY KEY CLUSTERED ([SERVICE_FACILITY_MIX_ID] ASC),
    CONSTRAINT [FK_ServiceFacilityMix_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ServiceFacilityMix_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_ServiceFacilityMix_ServiceMasterInventory] FOREIGN KEY ([SERVICE_MASTER_INVENTORY_ID]) REFERENCES [dbo].[ServiceMasterInventory] ([SERVICE_MASTER_INVENTORY_ID]),
    CONSTRAINT [FK_ServiceFacilityMix_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


GO
ALTER TABLE [dbo].[ServiceFacilityMix] NOCHECK CONSTRAINT [FK_ServiceFacilityMix_ServiceMasterInventory];

