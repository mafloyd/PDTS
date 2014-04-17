CREATE TABLE [dbo].[PdtsUser] (
    [USER_ID]                           INT           IDENTITY (1, 1) NOT NULL,
    [NT_ID]                             VARCHAR (20)  NULL,
    [LAST_NAME]                         VARCHAR (50)  NULL,
    [FIRST_NAME]                        VARCHAR (50)  NOT NULL,
    [ADMINISTRATOR]                     BIT           CONSTRAINT [DF_PdtsUser_ADMINISTRATOR] DEFAULT ((0)) NOT NULL,
    [ACTIVE]                            BIT           CONSTRAINT [DF_PdtsUser_ACTIVE] DEFAULT ((1)) NOT NULL,
    [CREATED_BY_USER_ID]                INT           NOT NULL,
    [CREATE_DATE]                       DATETIME      CONSTRAINT [DF_PdtsUser_CREATE_DATE] DEFAULT (getdate()) NOT NULL,
    [UPDATED_BY_USER_ID]                INT           NULL,
    [UPDATE_DATE]                       DATETIME      NULL,
    [MIDDLE_NAME]                       VARCHAR (50)  NULL,
    [FULL_NAME]                         VARCHAR (150) NULL,
    [EMAIL]                             VARCHAR (50)  NULL,
    [SEND_PROVIDER_CHANGE_NOTIFICATION] BIT           CONSTRAINT [DF_PdtsUser_SEND_PROVIDER_CHANGE_NOTIFICATION] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PdtsUser] PRIMARY KEY CLUSTERED ([USER_ID] ASC),
    CONSTRAINT [FK_PdtsUser_PdtsCreatedByUser] FOREIGN KEY ([CREATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_PdtsUser_PdtsUpdatedByUser] FOREIGN KEY ([UPDATED_BY_USER_ID]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

