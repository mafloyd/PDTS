CREATE TABLE [dbo].[CurrentYear_Admit_Note_Xref] (
    [CURRENTYEAR_ADMIT_NOTE_XREF_ID] INT IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]               INT NULL,
    [CURRENTYEAR_ADMIT_ID]           INT NOT NULL,
    [NOTE_ID]                        INT NOT NULL,
    CONSTRAINT [PK_CurrentYear_Admit_Note_Xref] PRIMARY KEY CLUSTERED ([CURRENTYEAR_ADMIT_NOTE_XREF_ID] ASC),
    CONSTRAINT [FK_CurrentYear_Admit_Note_Xref_CurrentYear_Admit] FOREIGN KEY ([CURRENTYEAR_ADMIT_ID]) REFERENCES [dbo].[CurrentYear_Admit] ([CURRENTYEAR_ADMIT_ID]),
    CONSTRAINT [FK_CurrentYear_Admit_Note_Xref_Note] FOREIGN KEY ([NOTE_ID]) REFERENCES [dbo].[Note] ([NOTE_ID])
);

