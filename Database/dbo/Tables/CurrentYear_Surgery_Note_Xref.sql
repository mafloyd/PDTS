CREATE TABLE [dbo].[CurrentYear_Surgery_Note_Xref] (
    [CURRENTYEAR_SURGERY_NOTE_XREF_ID] INT IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]                 INT NOT NULL,
    [NOTE_ID]                          INT NOT NULL,
    [CURRENTYEAR_SURGERY_ID]           INT NOT NULL,
    CONSTRAINT [PK_CurrentYear_Surgery_Note_Xref] PRIMARY KEY CLUSTERED ([CURRENTYEAR_SURGERY_NOTE_XREF_ID] ASC),
    CONSTRAINT [FK_CurrentYear_Surgery_Note_Xref_CurrentYear_Surgery] FOREIGN KEY ([CURRENTYEAR_SURGERY_ID]) REFERENCES [dbo].[CurrentYear_Surgery] ([CURRENTYEAR_SURGERY_ID]),
    CONSTRAINT [FK_CurrentYear_Surgery_Note_Xref_Note] FOREIGN KEY ([NOTE_ID]) REFERENCES [dbo].[Note] ([NOTE_ID]),
    CONSTRAINT [FK_CurrentYear_Surgery_Note_Xref_Provider] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE
);

