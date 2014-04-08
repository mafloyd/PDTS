CREATE TABLE [dbo].[Material_Physician_Reason] (
    [material_physician_reason_id] INT          IDENTITY (1, 1) NOT NULL,
    [name]                         VARCHAR (25) NOT NULL,
    [created_by_user_id]           INT          NOT NULL,
    [create_date]                  DATETIME     CONSTRAINT [DF__Material___creat__509CA826] DEFAULT (getdate()) NULL,
    [updated_by_user_id]           INT          NULL,
    [updated_date]                 DATETIME     NULL,
    CONSTRAINT [PK_Material_Physician_Reason] PRIMARY KEY CLUSTERED ([material_physician_reason_id] ASC),
    CONSTRAINT [FK_Material_Physician_Reason_PdtsUser] FOREIGN KEY ([created_by_user_id]) REFERENCES [dbo].[PdtsUser] ([USER_ID]),
    CONSTRAINT [FK_Material_Physician_Reason_PdtsUser1] FOREIGN KEY ([updated_by_user_id]) REFERENCES [dbo].[PdtsUser] ([USER_ID])
);

