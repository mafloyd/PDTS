CREATE TABLE [dbo].[ProviderPracticeAddress] (
    [PROVIDER_PRACTICE_ADDRESS_ID] INT          IDENTITY (1, 1) NOT NULL,
    [ADDRESS1]                     VARCHAR (50) NULL,
    [ADDRESS2]                     VARCHAR (50) NULL,
    [CITY]                         VARCHAR (50) NULL,
    [STATE_ID]                     INT          NULL,
    [ZIP_CODE]                     VARCHAR (9)  NULL,
    [PREFERRED]                    BIT          NOT NULL,
    [ACTIVE]                       BIT          NOT NULL,
    [CREATE_DATE]                  DATETIME     CONSTRAINT [DF_ProviderPracticeAddress_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID]           INT          NOT NULL,
    [UPDATE_DATE]                  DATETIME     NULL,
    [UPDATED_BY_USER_ID]           INT          NULL,
    [PHONE_NUMBER]                 VARCHAR (10) NULL,
    [FAX_NUMBER]                   VARCHAR (10) NULL,
    CONSTRAINT [PK_Provider_Practice_Address] PRIMARY KEY CLUSTERED ([PROVIDER_PRACTICE_ADDRESS_ID] ASC),
    CONSTRAINT [FK_Provider_Practice_Address_CreateUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_Provider_Practice_Address_State] FOREIGN KEY ([STATE_ID]) REFERENCES [dbo].[State] ([STATE_ID]),
    CONSTRAINT [FK_Provider_Practice_Address_UpdateUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

