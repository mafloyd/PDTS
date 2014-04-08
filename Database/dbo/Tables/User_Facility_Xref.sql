CREATE TABLE [dbo].[User_Facility_Xref] (
    [USER_ID]            INT         NOT NULL,
    [COID]               VARCHAR (5) NOT NULL,
    [ACTIVE]             BIT         CONSTRAINT [DF_User_Facility_Xref_ACTIVE] DEFAULT ((1)) NOT NULL,
    [CREATE_DATE]        DATETIME    CONSTRAINT [DF_User_Facility_Xref_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [CREATED_BY_USER_ID] INT         NOT NULL,
    [UPDATE_DATE]        DATETIME    NULL,
    [UPDATED_BY_USER_ID] INT         NULL,
    CONSTRAINT [PK_User_Facility_Xref_1] PRIMARY KEY CLUSTERED ([USER_ID] ASC, [COID] ASC),
    CONSTRAINT [FK_User_Facility_Xref_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID]),
    CONSTRAINT [FK_User_Facility_Xref_PdtsUser] FOREIGN KEY ([USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_User_Facility_Xref_PdtsUser1] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_User_Facility_Xref_PdtsUser2] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);


GO
ALTER TABLE [dbo].[User_Facility_Xref] NOCHECK CONSTRAINT [FK_User_Facility_Xref_Facility];

