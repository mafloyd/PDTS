CREATE TABLE [dbo].[Provider_Phone] (
    [PROVIDER_PHONE_ID]  INT         NOT NULL,
    [PDTS_PROVIDER_ID]   INT         NOT NULL,
    [PHONE_TYPE_ID]      INT         NOT NULL,
    [AREA_CODE]          NUMERIC (3) NOT NULL,
    [EXCHANGE]           NUMERIC (3) NOT NULL,
    [LOCAL_NUMBER]       NUMERIC (4) NULL,
    [PREFERRED]          BIT         NOT NULL,
    [ACTIVE]             BIT         NOT NULL,
    [CREATE_DATE]        DATETIME    NOT NULL,
    [CREATED_BY_USER_ID] INT         NOT NULL,
    [UPDATE_DATE]        DATETIME    NULL,
    [UPDATED_BY_USER_ID] INT         NULL,
    CONSTRAINT [PK_Provider_Phone] PRIMARY KEY CLUSTERED ([PROVIDER_PHONE_ID] ASC),
    CONSTRAINT [FK_Provider_Phone_PdtsUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_Provider_Phone_PdtsUser1] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_Provider_Phone_Phone_Type] FOREIGN KEY ([PHONE_TYPE_ID]) REFERENCES [dbo].[Phone_Type] ([PHONE_TYPE_ID]),
    CONSTRAINT [FK_Provider_Phone_Provider] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE
);

