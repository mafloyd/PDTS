CREATE TABLE [dbo].[ProviderVolumeStatus] (
    [PROVIDER_VOLUME_STATUS_ID] INT          IDENTITY (1, 1) NOT NULL,
    [NAME]                      VARCHAR (50) NOT NULL,
    [CREATE_DATE]               DATETIME     CONSTRAINT [DF_ProviderVolumeStatus_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]        INT          NOT NULL,
    [UPDATE_DATE]               DATETIME     NULL,
    [UPDATED_BY_USER_ID]        INT          NULL,
    CONSTRAINT [PK_ProviderVolumeStatus] PRIMARY KEY CLUSTERED ([PROVIDER_VOLUME_STATUS_ID] ASC),
    CONSTRAINT [FK_ProviderVolumeStatus_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_ProviderVolumeStatus_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

